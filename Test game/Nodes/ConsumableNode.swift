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
        static let particleName = "FireParticles.sks"
        static let size: CGFloat = 15
        static let scale: CGFloat = 0.25
        static let mass: CGFloat = 0.1
    }
    
    init(position: CGPoint) {
        super.init()
        
        guard let consumable = SKEmitterNode(fileNamed: Constants.particleName) else { return }        
        consumable.particleScale = Constants.scale
        self.position = position
        addChild(consumable)
        let radius = Constants.size // Since offset can be considered as radius
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.affectedByGravity = false
        physicsBody?.mass = Constants.mass
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
