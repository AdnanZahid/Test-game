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
    
    var shieldSprite: SKSpriteNode!
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        backgroundColor = .black
        loadShield()
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    
    private func loadShield() {
        let shieldAtlas = SKTextureAtlas(named: "Shield.atlas")
        var shieldArray: [SKTexture] = []
        
        let imageCount = shieldAtlas.textureNames.count
        (1...imageCount).forEach { index in
            let textureName = "image\(index)"
            shieldArray.append(shieldAtlas.textureNamed(textureName))
        }
        
        shieldSprite = SKSpriteNode(texture: shieldArray.first)
        let animateAction = SKAction.animate(with: shieldArray, timePerFrame: 0.1)
        let shieldAction = SKAction.repeatForever(SKAction.group([ animateAction ]))
        shieldSprite.run(shieldAction)
        shieldSprite.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(shieldSprite)
        
        shieldSprite.physicsBody = SKPhysicsBody(circleOfRadius: shieldSprite.size.width/2)
        shieldSprite.physicsBody?.restitution = 1.0
    }
}
