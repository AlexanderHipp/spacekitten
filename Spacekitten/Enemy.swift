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
    
    enum EnemyType {
        case Donut, Apple, Cookie, Scoop, Lollipop
        var spec: (texture: String, speed: CGFloat, name: String) {
            switch self {
            case Donut: return (texture: "Donut", speed: 1.5, name: "Donut")
            case Apple: return (texture: "Apple", speed: 1.7, name: "Apple")
            case Cookie: return (texture: "Cookie", speed: 1.3, name: "Cookie")
            case Scoop: return (texture: "Scoop", speed: 1.1, name: "Scoop")
            case Lollipop: return (texture: "Lollipop", speed: 0.9, name: "Lollipop")
            }
        }
    }
    
    
    // Return a new enemy sprite which follows the targetSprite node
    func spawnEnemy(sizeScreen: CGSize, currentLevel: Int) -> SKSpriteNode {
        
        // create a new enemy sprite
        let enemyTypeValue = whichEnemyTypeWillBeDisplayed(currentLevel)
        let newEnemy = SKSpriteNode(imageNamed:enemyTexture(enemyTypeValue))
        
        enemySprites.append(newEnemy)
        
        // position new sprite at a random position on the screen
        newEnemy.position = defineEnemyPosition(sizeScreen, enemySize: CGSize(width: 60, height: 60))
        
        // Name the node
        newEnemy.name = enemyName(enemyTypeValue)
        
        // Z-Position
        newEnemy.zPosition = 50
        
        // Apply physics
        newEnemy.physicsBody = SKPhysicsBody(circleOfRadius: newEnemy.size.width / 2)
        newEnemy.physicsBody?.dynamic = true
        newEnemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        newEnemy.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // Create the action: Movement to target (player's mouth)
        newEnemy.runAction(SKAction.moveTo(CGPoint(x: sizeScreen.width/2, y: sizeScreen.height/2), duration: NSTimeInterval(enemySpeed(enemyTypeValue))))
        
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
    
    
    func enemyTexture(type: EnemyType) -> String {
        
        var textureEnemy: String
        
        switch type {
        case .Donut:
            textureEnemy = EnemyType.Donut.spec.texture
        case .Apple:
            textureEnemy = EnemyType.Apple.spec.texture
        case .Cookie:
            textureEnemy = EnemyType.Cookie.spec.texture
        case .Scoop:
            textureEnemy = EnemyType.Scoop.spec.texture
        case .Lollipop:
            textureEnemy = EnemyType.Lollipop.spec.texture
        }
        return textureEnemy
        
    }
    
    
    func enemySpeed(type: EnemyType) -> CGFloat {
        
        var speedEnemy: CGFloat
        
        switch type {
        case .Donut:
            speedEnemy = EnemyType.Donut.spec.speed
        case .Apple:
            speedEnemy = EnemyType.Apple.spec.speed
        case .Cookie:
            speedEnemy = EnemyType.Cookie.spec.speed
        case .Scoop:
            speedEnemy = EnemyType.Scoop.spec.speed
        case .Lollipop:
            speedEnemy = EnemyType.Lollipop.spec.speed
        }
        return speedEnemy
        
    }
    
    
    func enemyName(type: EnemyType) -> String {
        
        var nameEnemy: String
        
        switch type {
        case .Donut:
            nameEnemy = EnemyType.Donut.spec.name
        case .Apple:
            nameEnemy = EnemyType.Apple.spec.name
        case .Cookie:
            nameEnemy = EnemyType.Cookie.spec.name
        case .Scoop:
            nameEnemy = EnemyType.Scoop.spec.name
        case .Lollipop:
            nameEnemy = EnemyType.Lollipop.spec.name
        }
        return nameEnemy
        
    }
    
    
    func whichEnemyTypeWillBeDisplayed(currentLevel: Int) -> EnemyType {
        
        switch currentLevel {
        case 1:
            return getPossibleEnemies([.Donut, .Donut, .Donut, .Donut, .Cookie])
        case 2:
            return getPossibleEnemies([.Donut, .Donut, .Scoop, .Donut, .Apple])
        case 3:
            return getPossibleEnemies([.Donut, .Donut, .Cookie, .Lollipop, .Apple])
        case 4:
            return getPossibleEnemies([.Donut, .Donut, .Scoop, .Scoop, .Apple])
        case 5:
            return getPossibleEnemies([.Donut, .Cookie, .Scoop, .Lollipop, .Apple])
        case 6:
            return getPossibleEnemies([.Donut, .Cookie, .Scoop, .Lollipop, .Lollipop])
        case 7:
            return getPossibleEnemies([.Scoop, .Scoop, .Lollipop, .Lollipop, .Apple])
        case 8:
            return getPossibleEnemies([.Cookie, .Cookie, .Scoop, .Lollipop, .Apple])
        case 9:
            return getPossibleEnemies([.Donut, .Donut, .Cookie, .Lollipop, .Lollipop])
        case 10:
            return getPossibleEnemies([.Donut, .Scoop, .Cookie, .Lollipop, .Apple])
        default:
            return getPossibleEnemies([.Donut, .Apple])
        }
        
    }
    
    
    func getPossibleEnemies(enemyArray: [EnemyType]) -> EnemyType {
        
        let enemyToDisplay: EnemyType = enemyArray.sample()
        return enemyToDisplay
        
    }
    
    
    
}
