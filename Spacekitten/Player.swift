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
    
    let imageHead = "Ralph"
    
    func definePlayer(sizeScreen sizeScreen: CGSize) {
        
        // Calculate real player size
        definePlayerSize(sizeScreen)
        
        // Head
        playerHead.texture = textureAtlas.textureNamed(imageHead)
        //playerHead.size = CGSize(width: playerSize * 3 / 4, height: playerSize)
        playerHead.size = CGSize(width: 150, height: 200)
        playerHead.zPosition = 12
        playerHead.position = positionPlayer(sizeScreen)
        
        
        // Mouth
        playerMouth.texture = textureAtlas.textureNamed("black")
        playerMouth.size = CGSize(width: 1, height: 1)
        playerMouth.zPosition = 1
        playerMouth.position = positionPlayer(sizeScreen)
        
        // Spawn player to the scene
        addChild(playerHead)
        addChild(playerMouth)
        
        //waiting()
        //self.playerHead.runAction(waitingAnimation, withKey: "waitingAnimation")
        
    }
    
    func definePlayerSize(sizeScreen: CGSize) {
        playerSize = Int(setSizeForPlayer(sizeScreen))
    }
    
    func updatePlayerPhysics() {        
        //playerHead.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: self.imageMouth), size: playerMouth.size)
        playerHead.physicsBody = SKPhysicsBody(circleOfRadius: max(playerMouth.size.width / 2, playerMouth.size.height / 2))
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
        playerHead.runAction(SKAction.resizeByWidth(CGFloat(damage * 3 / 4), height: CGFloat(damage), duration: 0.5))
    }
    
    func positionPlayer(sizeScreen: CGSize) -> CGPoint {
        return CGPoint(x: sizeScreen.width * 0.5, y: sizeScreen.height * 0.5)
    }
    
    func setSizeForPlayer(sizeScreen: CGSize) -> Double {
        return Double(sizeScreen.width) / 2.5
    }
    
    
    func die(sizeScreen: CGSize) {
        
        // Stop all actions
        self.removeAllActions()
        
        definePlayerSize(sizeScreen)
        // playerHead.size = CGSize(width: playerSize * 3 / 4, height: playerSize)
        playerHead.size = CGSize(width: 150, height: 200)
        
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
    
    
    func hideWithAnimation() {
        self.runAction(SKAction.fadeAlphaTo(0, duration: 0.3))
    }
    
    func showWithAnimation() {
        self.runAction(SKAction.fadeAlphaTo(1, duration: 0.3))
    }
    
    
}
