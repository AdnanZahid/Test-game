//
//  ConsumableNode.swift
//  Test game
//
//  Created by Adnan Zahid on 7/18/19.
//  Copyright © 2019 Adnan Zahid. All rights reserved.
//

import Foundation
import SpriteKit

class ConsumableNode: SKNode {
    
    private enum Constants {
        static let fireParticlesOffset: CGFloat = 15
        static let particleScale: CGFloat = 0.25
    }
    
    init(position: CGPoint) {
        super.init()
        
        guard let consumable = SKEmitterNode(fileNamed: "FireParticles.sks") else {
            return
        }
        
        consumable.particleScale = Constants.particleScale
        self.position = position
        addChild(consumable)
        let radius = Constants.fireParticlesOffset // Since offset can be considered as radius
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.affectedByGravity = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
