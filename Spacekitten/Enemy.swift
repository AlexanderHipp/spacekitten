//
//  Enemy.swift
//  Ralph
//
//  Created by Alexander Hipp on 17/01/2017.
//  Copyright © 2017 LonelyGoldfish. All rights reserved.
//

import SpriteKit


class Enemy: SKNode {
    
    var enemySprites: [SKSpriteNode] = []
    
    let calculationOfRandom = Calculation()
    
    
    // Return a new enemy sprite which follows the targetSprite node
    func spawnEnemy(sizeScreen: CGSize) -> SKSpriteNode {
        
        // create a new enemy sprite
        let newEnemy = SKSpriteNode(imageNamed:"Donut")
        enemySprites.append(newEnemy)
        
        // position new sprite at a random position on the screen
        newEnemy.position = defineEnemyPosition(sizeScreen, enemySize: CGSize(width: 60, height: 60))
        
        // Name the node
        newEnemy.name = "Donut"
        
        // Z-Position
        newEnemy.zPosition = 50
        
        // Apply physics
        newEnemy.physicsBody = SKPhysicsBody(circleOfRadius: newEnemy.size.width / 2)
        newEnemy.physicsBody?.dynamic = true
        newEnemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        newEnemy.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // Create the action: Movement to target (player's mouth)
        newEnemy.runAction(SKAction.moveTo(CGPoint(x: sizeScreen.width/2, y: sizeScreen.height/2), duration: NSTimeInterval(1.5)))
        
        print("ARRAY", enemySprites)
        
        return newEnemy
        
    }
    
    func defineEnemyPosition(sizeScreen: CGSize, enemySize: CGSize) -> CGPoint {
        
        // Determine where to spawn the enemy along the Y axis, left or right
        let actualY = calculationOfRandom.random(min: enemySize.height/2, max: sizeScreen.height - enemySize.height/2)
        let leftSide = -enemySize.width/2
        let rightSide = sizeScreen.width + enemySize.width/2
        let actualSideLeftRight = [leftSide, rightSide]
        
        // left or right
        let positionLeftRight = CGPoint(x: actualSideLeftRight.sample(), y: actualY)
        
        // Determine where to spawn the enemy along the x axis, bottom or top
        let actualX = calculationOfRandom.random(min: enemySize.width/2, max: sizeScreen.width - enemySize.width/2)
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
