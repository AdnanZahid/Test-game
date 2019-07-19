//
//  LightNode.swift
//  Test game
//
//  Created by Adnan Zahid on 7/18/19.
//  Copyright © 2019 Adnan Zahid. All rights reserved.
//

import Foundation
import SpriteKit

class LightNode: SKNode {
    private enum Constants {
        static let particleName = "FireParticles.sks"
        static let twoPi = CGFloat.pi * 2
        static let particleOffset: CGFloat = 15
        static let durationOfRotation: TimeInterval = 5
        static let damping: CGFloat = 25
        static let impulse = CGVector(dx: 0, dy: 30)
        static let maximumScale: CGFloat = 1.5
        static let mass: CGFloat = 1.0
        static let springFieldRadius: Float = 50
        static let springFieldStrength: Float = 1.0
        static let energyDecay: CGFloat = 0.005
        static let energyIncrement: CGFloat = 0.5
        static let decayInterval = 0.1
        static let decayThreshold: CGFloat = 0.1
    }
    
    private var hasContactedConsumable = false
    
    init(position: CGPoint) {
        super.init()
        
        [CGPoint(x: position.x + Constants.particleOffset,
                 y: position.y),
         CGPoint(x: position.x - Constants.particleOffset,
                 y: position.y),
         CGPoint(x: position.x,
                 y: position.y + Constants.particleOffset),
         CGPoint(x: position.x,
                 y: position.y - Constants.particleOffset)].forEach { position in
                    guard let particle = SKEmitterNode(fileNamed: Constants.particleName) else { return }
                    particle.particleScale = Constants.maximumScale
                    particle.position = position
                    addChild(particle)
                    particle.run(SKAction.repeatForever(
                        SKAction.sequence([
                            SKAction.wait(forDuration: Constants.decayInterval),
                            SKAction.run {
                                let decrementedScale = particle.particleScale - Constants.energyDecay
                                guard decrementedScale >= Constants.decayThreshold else { return }
                                particle.particleScale = decrementedScale
                            }])))
        }
        
        let radius = Constants.particleOffset // Since offset can be considered as radius
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.linearDamping = Constants.damping
        physicsBody?.mass = Constants.mass
        physicsBody?.affectedByGravity = false // TODO: Remove this, it is temporary
        
        let oneRevolution = SKAction.rotate(byAngle: Constants.twoPi,
                                            duration: Constants.durationOfRotation)
        let repeatRotation = SKAction.repeatForever(oneRevolution)
        
        run(repeatRotation)
        
        let field = SKFieldNode.springField()
        field.region = SKRegion(radius: Constants.springFieldRadius)
        field.strength = Constants.springFieldStrength
        addChild(field)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LightNode {
    func setIsNearConsumable() { // Used to start the revolution of consumable
        hasContactedConsumable = true
        
        children.forEach { child in
            guard let child = child as? SKEmitterNode else { return }
            let incrementedScale = child.particleScale + Constants.energyIncrement
            guard incrementedScale <= Constants.maximumScale else { return }
            child.particleScale = incrementedScale
        }
    }
    
    func setHasConsumedConsumable() { // Used to end the revolution of consumable
        hasContactedConsumable = false
    }
    
    func shouldPickupConsumable() -> Bool { // Used to determine whether to end the revolution of consumable
        return hasContactedConsumable
    }
}
