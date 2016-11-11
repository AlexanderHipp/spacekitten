//
//  Player.swift
//  Spacekitten
//
//  Created by Alexander Hipp on 25/07/16.
//  Copyright © 2016 LonelyGoldfish. All rights reserved.
//

import SpriteKit


class Player: SKNode {
    
    let playerHead = SKSpriteNode()
    let playerMouth = SKSpriteNode()
    
    var waitingAnimation = SKAction()
    
    // Initialize variable for the player
    var playerSize: Int = 1
    var initialPlayerSize: Int = 1
    
    
    let textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "sprites.atlas")
    
    let imageHead = "waiting-1"
    let imageMouth = "mouth"
    
    func definePlayer(sizeScreen sizeScreen: CGSize) {
        
        // Calculate real player size
        playerSize = setSizeForPlayer(sizeScreen)
        
        // Head
        playerHead.texture = textureAtlas.textureNamed(imageHead)
        playerHead.size = CGSize(width: playerSize, height: playerSize)
        playerHead.zPosition = 12
        playerHead.position = positionPlayer(sizeScreen)
        
        
        // Mouth
        playerMouth.texture = textureAtlas.textureNamed("black")
        playerMouth.size = CGSize(width: 4, height: 4)
        playerMouth.zPosition = 13
        playerMouth.position = positionPlayer(sizeScreen)
        
        // Spawn player to the scene
        addChild(playerHead)
        addChild(playerMouth)
        
        waiting()
        self.playerHead.runAction(waitingAnimation, withKey: "waitingAnimation")
        
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
      
        // check if the player gets hit by a good enemy or a bad enemy to check different situations
        if (damage < 0) {
            
            // If player is not so big to hit the edge and is not smaller than the initial player size than it should be grown
            if (self.playerHead.size.width <= sizeScreen.width) && (self.playerHead.size.width >= CGFloat(initialPlayerSize)) {
                self.resizePlayer(damage)
            }
            
        } else if (damage > 0) {
            
            // If player is not so big to hit the edge than it should be grown
            if (self.playerHead.size.width <= sizeScreen.width) {
                self.resizePlayer(damage)
            }
            
        } else {
            // do nothing
        }
       
    }
    
    func resizePlayer(damage: Int) {
        playerHead.runAction(SKAction.resizeByWidth(CGFloat(damage), height: CGFloat(damage), duration: 0.5))
    }
    
    func positionPlayer(sizeScreen: CGSize) -> CGPoint {
        return CGPoint(x: sizeScreen.width * 0.5, y: sizeScreen.height * 0.5)
    }
    
    func setSizeForPlayer(sizeScreen: CGSize) -> Int {
        return Int(sizeScreen.width) / 3
    }
    
    
    func die(sizeScreen: CGSize) {
        
        // Stop all actions
        self.removeAllActions()
        
        playerSize = setSizeForPlayer(sizeScreen)
        playerHead.size = CGSize(width: playerSize, height: playerSize)
        
        // TODO: Schöner schrumpfen lassen
        
    }
    
    // Function for the waiting animation
    func waiting() {
        
        let waitingFrames: [SKTexture] = [
            textureAtlas.textureNamed("waiting-1"),
            textureAtlas.textureNamed("waiting-2"),
            textureAtlas.textureNamed("waiting-3"),
            textureAtlas.textureNamed("waiting-2")
        ]
        
        let waitingAction = SKAction.animateWithTextures(waitingFrames, timePerFrame: 0.6)
        
        waitingAnimation = SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.repeatAction(waitingAction, count: 2),
                SKAction.waitForDuration(3)
            ])
        )
    }
    
    
    
}
