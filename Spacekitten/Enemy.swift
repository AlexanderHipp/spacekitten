//
//  Enemy.swift
//  Spacekitten
//
//  Created by Alexander Hipp on 13/07/16.
//  Copyright © 2016 LonelyGoldfish. All rights reserved.
//

import SpriteKit



class Enemy: SKNode {
        
    let enemy = SKSpriteNode()
    let calculationOfRandom = Calculation()
    
    let colorEnemy:[String] = ["blue", "yellow", "green", "orange", "purple"]
    let textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "sprites.atlas")
    
    func giveEnemySize() -> CGSize {
        // Size of enemy
        let sizeEnemy = calculationOfRandom.random(min: CGFloat(10.0), max: CGFloat(20.0))
        enemy.size = CGSize(width: sizeEnemy, height: sizeEnemy)
        return enemy.size
    }
    
    
    func addEnemy(initPosition: CGPoint, sizeScreen: CGSize) {                
        
        let currentColor = colorEnemy.sample()
        enemy.texture = textureAtlas.textureNamed(currentColor)
        enemy.position = initPosition
        
        // Add the enemy to the scene
        addChild(enemy)
        
        // Apply physics
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        enemy.physicsBody?.dynamic = true
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        enemy.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // Determine speed of the enemy
        let actualDuration = calculationOfRandom.random(min: CGFloat(1.0), max: CGFloat(8.0))
        
        // Create the actions
        enemy.runAction(SKAction.moveTo(CGPoint(x: sizeScreen.width/2, y: sizeScreen.height/2), duration: NSTimeInterval(actualDuration)))
 
    }
    
    func defineEnemyPosition(sizeScreen: CGSize, enemySize: CGSize) -> CGPoint {
        
        // Determine where to spawn the enemy along the Y axis, left or right
        let actualY = calculationOfRandom.random(min: enemy.size.height/2, max: sizeScreen.height - enemy.size.height/2)
        let leftSide = -enemySize.width/2
        let rightSide = sizeScreen.width + enemySize.width/2
        let actualSideLeftRight = [leftSide, rightSide]
        
        // left or right
        let positionLeftRight = CGPoint(x: actualSideLeftRight.sample(), y: actualY)
        
        // Determine where to spawn the enemy along the x axis, bottom or top
        let actualX = calculationOfRandom.random(min: enemy.size.width/2, max: sizeScreen.width - enemy.size.width/2)
        let bottomSide = -enemySize.height/2
        let topSide = sizeScreen.height + enemySize.height/2
        let actualSideBottomTop = [bottomSide, topSide]
        
        // bottom or top
        let positionBottomTop = CGPoint(x: actualX, y: actualSideBottomTop.sample())
        
        // Choose random side
        let leftRightBottomTop = [positionLeftRight, positionBottomTop]
        
        
        return leftRightBottomTop.sample()
        
    }
    
    
}


