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
        static let twoPi = CGFloat.pi * 2
        static let fireParticlesOffset: CGFloat = 10
        static let durationOfRotation: TimeInterval = 5
        static let dampingOfLightNode: CGFloat = 100
        static let impulseOnLightNode = CGVector(dx: 0, dy: 30)
    }
    
    init(position: CGPoint) {
        super.init()
        
        guard let particle1 = SKEmitterNode(fileNamed: "FireParticles.sks"),
            let particle2 = SKEmitterNode(fileNamed: "FireParticles.sks"),
            let particle3 = SKEmitterNode(fileNamed: "FireParticles.sks") else {
                return
        }
        
        particle1.position = CGPoint(x: position.x,
                                     y: position.y - Constants.fireParticlesOffset)
        particle2.position = CGPoint(x: position.x - Constants.fireParticlesOffset,
                                     y: position.y)
        particle3.position = CGPoint(x: position.x,
                                     y: position.y + Constants.fireParticlesOffset)
        addChild(particle1)
        addChild(particle2)
        addChild(particle3)
        let radius = Constants.fireParticlesOffset // Since offset can be considered as radius
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.linearDamping = Constants.dampingOfLightNode
        
        let oneRevolution = SKAction.rotate(byAngle: Constants.twoPi,
                                            duration: Constants.durationOfRotation)
        let repeatRotation = SKAction.repeatForever(oneRevolution)
        
        run(repeatRotation)
        
        
        let field = SKFieldNode.linearGravityField(withVector: vector_float3(1, 1, 1))
        field.strength = 0.1
        addChild(field)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
