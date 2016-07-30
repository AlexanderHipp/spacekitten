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
    
    let player = SKSpriteNode()
    var playerSize = 60
    let textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "sprites.atlas")
    
    func definePlayer(sizeScreen: CGSize) {
        player.texture = textureAtlas.textureNamed("blue")
        player.size = CGSize(width: playerSize, height: playerSize)
        player.zPosition = 13
        player.position = positionPlayer(sizeScreen)
        addChild(player)
    }
    
    func updatePlayerPhysics() {
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.dynamic = false
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        player.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
    
    func widthOfPlayer() -> CGFloat {
        return player.size.width
    }
    
    func heightOfPlayer() -> CGFloat {
        return player.size.height
    }
    
    func growPlayerWhenHit(damage: Int) {
        // How much player grows when he gets hit
        playerSize += damage
        player.size = CGSize(width: playerSize, height: playerSize)        
    }
    
    func positionPlayer(sizeScreen: CGSize) -> CGPoint {
        return CGPoint(x: sizeScreen.width * 0.5, y: sizeScreen.height * 0.5)
    }
    
    
    func die() {
        self.alpha = 1
        self.removeAllActions()
//        self.runAction(self.dieAnimation)
        
    }
    
    
    
}