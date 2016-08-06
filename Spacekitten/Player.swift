//
//  Player.swift
//  Spacekitten
//
//  Created by Alexander Hipp on 25/07/16.
//  Copyright © 2016 LonelyGoldfish. All rights reserved.
//

import SpriteKit


class Player: SKNode {
    
    // define player    
    
    let playerFace = SKSpriteNode()
    let playerHead = SKSpriteNode()
    
    var playerSize = 145
    let textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "sprites.atlas")
    
    func definePlayer(sizeScreen: CGSize) {
        
        // Head
        playerHead.texture = textureAtlas.textureNamed("Ralph-head")
        playerHead.size = CGSize(width: playerSize, height: playerSize)
        playerHead.zPosition = 12
        playerHead.position = positionPlayer(sizeScreen)
        
        // Face
        playerFace.texture = textureAtlas.textureNamed("Ralph-face")
        playerFace.size = CGSize(width: playerSize, height: playerSize)
        playerFace.zPosition = 13
        playerFace.position = positionPlayer(sizeScreen)
        
        addChild(playerHead)
        addChild(playerFace)
    }
    
    func updatePlayerPhysics() {
        playerHead.physicsBody = SKPhysicsBody(rectangleOfSize: playerHead.size)
        playerHead.physicsBody?.dynamic = false
        playerHead.physicsBody?.categoryBitMask = PhysicsCategory.Player
        playerHead.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        playerHead.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
    
    func widthOfPlayer() -> CGFloat {
        return playerHead.size.width
    }
    
    func heightOfPlayer() -> CGFloat {
        return playerHead.size.height
    }
    
    func growPlayerWhenHit(damage: Int) {
        // How much player grows when he gets hit
        playerSize += damage
        playerHead.size = CGSize(width: playerSize, height: playerSize)
    }
    
    func positionPlayer(sizeScreen: CGSize) -> CGPoint {
        return CGPoint(x: sizeScreen.width * 0.5, y: sizeScreen.height * 0.5)
    }
    
    
    func die() {
        self.alpha = 0
        self.removeAllActions()
//        self.runAction(self.dieAnimation)
        
    }
    
    
    
}