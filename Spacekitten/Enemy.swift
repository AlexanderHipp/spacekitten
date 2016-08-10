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
    let textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "sprites.atlas")
    
    enum EnemyType {
        case Taubsi, Pikachu, Relaxo
        var spec: (size: CGSize, color: String, speed: CGFloat, name: String) {
            switch self {
            case Taubsi: return (size: CGSize(width: 30, height: 30), color: "donut", speed: 2.5, name: "Taubsi")
            case Pikachu: return (size: CGSize(width: 20, height: 20), color: "yellow", speed: 4.0, name: "Pikachu")
            case Relaxo: return (size: CGSize(width: 50, height: 50), color: "blue", speed: 10.0, name: "Relaxo")
            // add name to the enum to check what hit the player
            }
        }
    }
    
    
    func defineEnemySpecFor(currentLevel: Int, sizeScreen: CGSize) {
        
        let enemyTypeValue = whichEnemyTypeWillBeDisplayed(currentLevel)

        let sizeOfEnemy = enemySize(enemyTypeValue)
        let enemyRandomPosition = defineEnemyPosition(sizeScreen, enemySize: sizeOfEnemy)
        
        self.addEnemy(
            sizeOfEnemy,
            initPosition: enemyRandomPosition,
            sizeScreen: sizeScreen,
            texture: enemyTexture(enemyTypeValue),
            speed: enemySpeed(enemyTypeValue),
            typeName: enemyName(enemyTypeValue)
        )
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
    
    
    func addEnemy(size: CGSize, initPosition: CGPoint, sizeScreen: CGSize, texture: String, speed: CGFloat, typeName: String) {
        
        enemy.texture = textureAtlas.textureNamed(texture)
        enemy.position = initPosition
        enemy.size = size
        enemy.name = typeName
        
        // Add the enemy to the scene
        self.addChild(enemy)
        
        
        // Apply physics
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        enemy.physicsBody?.dynamic = true
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        enemy.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // Create the actions
        enemy.runAction(SKAction.moveTo(CGPoint(x: sizeScreen.width/2, y: sizeScreen.height/2), duration: NSTimeInterval(speed)))
 
    }
    
    func enemySize(type: EnemyType) -> CGSize {
        
        var sizeEnemy: CGSize
        
        switch type {
        case .Taubsi:
            sizeEnemy = EnemyType.Taubsi.spec.size
        case .Pikachu:
            sizeEnemy = EnemyType.Pikachu.spec.size
        case .Relaxo:
            sizeEnemy = EnemyType.Relaxo.spec.size
        }
        return sizeEnemy
    }
    
    
    
    func enemyTexture(type: EnemyType) -> String {
        
        var textureEnemy: String
        
        switch type {
        case .Taubsi:
            textureEnemy = EnemyType.Taubsi.spec.color
        case .Pikachu:
            textureEnemy = EnemyType.Pikachu.spec.color
        case .Relaxo:
            textureEnemy = EnemyType.Relaxo.spec.color
        }
        
        return textureEnemy
        
    }
    
    
    func enemySpeed(type: EnemyType) -> CGFloat {
        
        var speedEnemy: CGFloat
        
        switch type {
        case .Taubsi:
            speedEnemy = EnemyType.Taubsi.spec.speed
        case .Pikachu:
            speedEnemy = EnemyType.Pikachu.spec.speed
        case .Relaxo:
            speedEnemy = EnemyType.Relaxo.spec.speed
        }
        return speedEnemy
        
    }
    
    
    func enemyName(type: EnemyType) -> String {
        
        var nameEnemy: String
        
        switch type {
        case .Taubsi:
            nameEnemy = EnemyType.Taubsi.spec.name
        case .Pikachu:
            nameEnemy = EnemyType.Pikachu.spec.name
        case .Relaxo:
            nameEnemy = EnemyType.Relaxo.spec.name
        }
        return nameEnemy
        
    }
    
    
    func removeAllEnemies() {
        self.enemy.removeFromParent()
    }
    
    
    func whichEnemyTypeWillBeDisplayed(currentLevel: Int) -> EnemyType {
        
        switch currentLevel {
        case 1:
            return EnemyType.Pikachu
        default:
            return EnemyType.Taubsi
        }
        
    }
    
}

















