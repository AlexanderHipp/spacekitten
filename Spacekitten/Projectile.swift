//
//  Projectile.swift
//  Spacekitten
//
//  Created by Alexander Hipp on 13/07/16.
//  Copyright © 2016 LonelyGoldfish. All rights reserved.
//

import SpriteKit

class Projectile: SKNode {
    
    let projectile = SKSpriteNode()
    let textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "sprites.atlas")

    func createProjectile(touchLocation: CGPoint, playerPosition: CGPoint) {
        
        // Set up initial location of projectile
        projectile.texture = textureAtlas.textureNamed("blue")
        projectile.position = playerPosition
        projectile.size = CGSize(width: 10, height: 10)
        projectile.zPosition = 1
        
        // Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        // OK to add now - you've double checked position
        self.addChild(projectile)
        
        // Get the direction of where to shoot
        let direction = offset.normalized()        

        // Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.dynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        // Create the actions
        let actionMove = SKAction.moveTo(realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
    }

}

