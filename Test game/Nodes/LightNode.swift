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
        static let particleSize: CGFloat = 10
        static let durationOfRotation: TimeInterval = 5
        static let damping: CGFloat = 100
        static let impulse = CGVector(dx: 0, dy: 30)
        static let mass: CGFloat = 1.0
        static let springFieldRadius: Float = 50
        static let springFieldStrength: Float = 1.0
    }
    
    private var hasContactedConsumable = false
    
    init(position: CGPoint) {
        super.init()
        
        [CGPoint(x: position.x + Constants.particleSize,
                 y: position.y),
         CGPoint(x: position.x - Constants.particleSize,
                 y: position.y),
         CGPoint(x: position.x,
                 y: position.y + Constants.particleSize),
         CGPoint(x: position.x,
                 y: position.y - Constants.particleSize)].forEach { position in
                    guard let particle = SKEmitterNode(fileNamed: Constants.particleName) else { return }
                    particle.position = position
                    addChild(particle)
        }
        
        let radius = Constants.particleSize // Since offset can be considered as radius
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.linearDamping = Constants.damping
        physicsBody?.mass = Constants.mass
        
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
    }
    
    func setHasConsumedConsumable() { // Used to end the revolution of consumable
        hasContactedConsumable = false
    }
    
    func shouldPickupConsumable() -> Bool { // Used to determine whether to end the revolution of consumable
        return hasContactedConsumable
    }
}
