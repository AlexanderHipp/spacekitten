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
    
    var playerHeight = 240
    var playerWidth = 170
    let textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "sprites.atlas")
    
    let imageRalphHead = "Ralph"
    let imageRalphFace = "Ralph-face"
    
    func definePlayer(sizeScreen: CGSize) {
        
        // Head
        playerHead.texture = textureAtlas.textureNamed(imageRalphHead)        
        playerHead.size = CGSize(width: playerWidth, height: playerHeight)
        playerHead.zPosition = 12
        playerHead.position = CGPoint(x: sizeScreen.width / 2, y: (sizeScreen.height / 2) - 250)
        
        // Mouth
        playerFace.size = CGSize(width: 20, height: 20)
        playerFace.zPosition = 13
        playerFace.position = CGPoint(x: sizeScreen.width / 2, y: (sizeScreen.height / 2) - 180)
        
        addChild(playerFace)
        addChild(playerHead)
    }
    
    func updatePlayerPhysics() {        
        playerFace.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: self.imageRalphFace), size: playerFace.size)
        playerFace.physicsBody?.dynamic = false
        playerFace.physicsBody?.categoryBitMask = PhysicsCategory.Player
        playerFace.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        playerFace.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
    
    func widthOfPlayer() -> CGFloat {
        return playerHead.size.width
    }
    
    func heightOfPlayer() -> CGFloat {
        return playerHead.size.height
    }
    
    func growPlayerWhenHit(damage: Int, sizeScreen: CGSize) {
        // How much player grows when he gets hit
        
//        if playerWidth <= Int(sizeScreen.width) {
//            playerWidth += damage
//            playerHeight += damage
//            playerHead.size = CGSize(width: playerWidth, height: playerHeight)
//        }
    }
    
    func die() {
        self.alpha = 0
        self.removeAllActions()
//        self.runAction(self.dieAnimation)
        
    }
    
    
    
}