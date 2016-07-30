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
    
    enum enemyType {
        case Taubsi, Pikachu, Relaxo
        var spec: (size: CGSize, color: String, speed: CGFloat, name: String) {
            switch self {
            case Taubsi: return (size: CGSize(width: 10, height: 10), color: "orange", speed: 1.0, name: "Taubsi")
            case Pikachu: return (size: CGSize(width: 20, height: 20), color: "yellow", speed: 4.0, name: "Pikachu")
            case Relaxo: return (size: CGSize(width: 50, height: 50), color: "blue", speed: 10.0, name: "Relaxo")
            // add name to the enum to check what hit the player
            }
        }
    }
    
    
    func defineEnemySpecFor(type: enemyType, sizeScreen: CGSize) {

        let sizeOfEnemy = enemySize(type)
        let enemyRandomPosition = defineEnemyPosition(sizeScreen, enemySize: sizeOfEnemy)
        
        self.addEnemy(
            sizeOfEnemy,
            initPosition: enemyRandomPosition,
            sizeScreen: sizeScreen,
            texture: enemyTexture(type),
            speed: enemySpeed(type),
            typeName: enemyName(type)            
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
    
    func enemySize(type: enemyType) -> CGSize {
        
        var sizeEnemy: CGSize
        
        switch type {
        case .Taubsi:
            sizeEnemy = enemyType.Taubsi.spec.size
        case .Pikachu:
            sizeEnemy = enemyType.Pikachu.spec.size
        case .Relaxo:
            sizeEnemy = enemyType.Relaxo.spec.size
        }
        return sizeEnemy
    }
    
    
    
    func enemyTexture(type: enemyType) -> String {
        
        var textureEnemy: String
        
        switch type {
        case .Taubsi:
            textureEnemy = enemyType.Taubsi.spec.color
        case .Pikachu:
            textureEnemy = enemyType.Pikachu.spec.color
        case .Relaxo:
            textureEnemy = enemyType.Relaxo.spec.color
        }
        
        return textureEnemy
        
    }
    
    
    func enemySpeed(type: enemyType) -> CGFloat {
        
        var speedEnemy: CGFloat
        
        switch type {
        case .Taubsi:
            speedEnemy = enemyType.Taubsi.spec.speed
        case .Pikachu:
            speedEnemy = enemyType.Pikachu.spec.speed
        case .Relaxo:
            speedEnemy = enemyType.Relaxo.spec.speed
        }
        return speedEnemy
        
    }
    
    
    func enemyName(type: enemyType) -> String {
        
        var nameEnemy: String
        
        switch type {
        case .Taubsi:
            nameEnemy = enemyType.Taubsi.spec.name
        case .Pikachu:
            nameEnemy = enemyType.Pikachu.spec.name
        case .Relaxo:
            nameEnemy = enemyType.Relaxo.spec.name
        }
        return nameEnemy
        
    }
    
    
    func removeAllEnemies() {
        self.enemy.removeFromParent()
    }
    
}


