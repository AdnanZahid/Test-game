//
//  GameScene.swift
//  Test game
//
//  Created by Adnan Zahid on 6/28/19.
//  Copyright © 2019 Adnan Zahid. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    private enum Constants {
        static let spawnDistance: CGFloat = -50
        static let impulseOnLightNode = CGVector(dx: 0, dy: 30)
        static let velocityOnConsumableNodes = CGVector(dx: -60, dy: 0)
    }
    
    private enum ContactTestBitMask {
        static let noCollision: UInt32 = 0
        static let lightNode: UInt32 = 1 << 1
        static let consumableNode: UInt32 = 1 << 2
    }
    
    var lightNode: SKNode!
    var consumableNodes: [SKNode] = []
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        backgroundColor = .black
        loadLightNode()
        loadConsumable()
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    private func identifyBody(with mask: UInt32,
                              bodyA: SKPhysicsBody,
                              bodyB: SKPhysicsBody) -> SKNode {
        guard let nodeA = bodyA.node,
            let nodeB = bodyB.node else { return SKNode() }
        return bodyA.categoryBitMask == mask ? nodeA : nodeB
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.contactTestBitMask | contact.bodyB.contactTestBitMask
        
        switch contactMask {
            
        case ContactTestBitMask.lightNode | ContactTestBitMask.consumableNode:
            let node = identifyBody(with: ContactTestBitMask.consumableNode,
                                    bodyA: contact.bodyA,
                                    bodyB: contact.bodyB)
            guard consumableNodes.contains(node) else { return }
//            node.removeFromParent()
            node.physicsBody?.velocity = CGVector.zero
            loadConsumable()
            
        default :
            return
        }
    }
}

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        lightNode.physicsBody?.applyImpulse(Constants.impulseOnLightNode)
    }
}

extension GameScene {
    private func loadConsumable() {
        let node = ConsumableNode(position: CGPoint(x: frame.maxX + Constants.spawnDistance,
                                                    y: frame.midY))
        node.physicsBody?.velocity = Constants.velocityOnConsumableNodes
        node.physicsBody?.contactTestBitMask = ContactTestBitMask.consumableNode
        node.physicsBody?.collisionBitMask = ContactTestBitMask.noCollision
        addChild(node)
        consumableNodes.append(node)
    }
}

extension GameScene {
    private func loadLightNode() {
        lightNode = LightNode(position: CGPoint(x: frame.midX,
                                                y: frame.midY))
        lightNode.physicsBody?.contactTestBitMask = ContactTestBitMask.lightNode
        lightNode.physicsBody?.collisionBitMask = ContactTestBitMask.noCollision
        addChild(lightNode)
    }
}
