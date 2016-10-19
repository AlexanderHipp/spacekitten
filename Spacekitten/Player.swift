//
//  Player.swift
//  Spacekitten
//
//  Created by Alexander Hipp on 25/07/16.
//  Copyright © 2016 LonelyGoldfish. All rights reserved.
//

import SpriteKit


class Player: SKNode {
    
    let playerFace = SKSpriteNode()
    let playerHead = SKSpriteNode()
    let playerMouth = SKSpriteNode()
    
    var playerSize = 150
    var playerInnerSize = 150
    
    
    let textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "sprites.atlas")
    
    let imageHead = "head"
    let imageFace = "face"
    let imageMouth = "mouth"
    
    func definePlayer(sizeScreen sizeScreen: CGSize) {
        
        playerSize = setSizeForPlayer(sizeScreen)
        playerInnerSize = playerSize
        
        // Head
        playerHead.texture = textureAtlas.textureNamed(imageHead)
        playerHead.size = CGSize(width: playerSize, height: playerSize)
        playerHead.zPosition = 12
        playerHead.position = positionPlayer(sizeScreen)
        
        // Face
        playerFace.texture = textureAtlas.textureNamed(imageFace)
        playerFace.size = CGSize(width: playerSize, height: playerSize)
        playerFace.zPosition = 13
        playerFace.position = positionPlayer(sizeScreen)
        
        // Mouth
        playerMouth.texture = textureAtlas.textureNamed(imageMouth)
        playerMouth.size = CGSize(width: playerSize, height: playerSize)
        playerMouth.zPosition = 14
        playerMouth.position = positionPlayer(sizeScreen)
        
        addChild(playerFace)
        addChild(playerHead)
        addChild(playerMouth)
    }
    
    func updatePlayerPhysics() {        
        playerHead.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: self.imageMouth), size: playerMouth.size)
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
    
    func growPlayerWhenHit(damage: Int, sizeScreen: CGSize) {
                        
        if playerSize <= Int(sizeScreen.width) {
            self.resizePlayer(damage, smallDamage: damage / 2)
        }
    }
    
    func resizePlayer(damage: Int, smallDamage: Int) {
        playerHead.runAction(SKAction.resizeByWidth(CGFloat(damage), height: CGFloat(damage), duration: 1.0))
        playerFace.runAction(SKAction.resizeByWidth(CGFloat(smallDamage), height: CGFloat(smallDamage), duration: 1.0))
        playerMouth.runAction(SKAction.resizeByWidth(CGFloat(smallDamage), height: CGFloat(smallDamage), duration: 1.0))
    }
    
    func positionPlayer(sizeScreen: CGSize) -> CGPoint {
        return CGPoint(x: sizeScreen.width * 0.5, y: sizeScreen.height * 0.5)
    }
    
    func setSizeForPlayer(sizeScreen: CGSize) -> Int {
        return Int(sizeScreen.width) / 3
    }
    
    
    func die(sizeScreen: CGSize) {
        self.removeAllActions()
        
        playerSize = setSizeForPlayer(sizeScreen)
        
        playerHead.size = CGSize(width: playerSize, height: playerSize)
        playerFace.size = CGSize(width: playerSize, height: playerSize)
        playerMouth.size = CGSize(width: playerSize, height: playerSize)
        
        
    }
    
    
    
}
