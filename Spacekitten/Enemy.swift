//
//  Enemy.swift
//  Spacekitten
//
//  Created by Alexander Hipp on 13/07/16.
//  Copyright © 2016 LonelyGoldfish. All rights reserved.
//

import SpriteKit

// test


class Enemy: SKNode {
    
    let enemyNode = SKSpriteNode()
    let calculationOfRandom = Calculation()
    let textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "sprites.atlas")
    
    enum EnemyType {
        case Donut, Apple, Cookie, Scoop, Lollipop
        var spec: (size: CGSize, color: String, speed: CGFloat, name: String) {
            switch self {
            case Donut: return (size: CGSize(width: 60, height: 60), color: "Donut", speed: 1.5, name: "Donut")
            case Apple: return (size: CGSize(width: 60, height: 60), color: "Apple", speed: 1.7, name: "Apple")
            case Cookie: return (size: CGSize(width: 60, height: 60), color: "Cookie", speed: 1.3, name: "Cookie")
            case Scoop: return (size: CGSize(width: 60, height: 60), color: "Scoop", speed: 1.1, name: "Scoop")
            case Lollipop: return (size: CGSize(width: 60, height: 60), color: "Lollipop", speed: 0.9, name: "Lollipop")
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
        let actualY = calculationOfRandom.random(min: enemyNode.size.height/2, max: sizeScreen.height - enemyNode.size.height/2)
        let leftSide = -enemySize.width/2
        let rightSide = sizeScreen.width + enemySize.width/2
        let actualSideLeftRight = [leftSide, rightSide]
        
        // left or right
        let positionLeftRight = CGPoint(x: actualSideLeftRight.sample(), y: actualY)
        
        // Determine where to spawn the enemy along the x axis, bottom or top
        let actualX = calculationOfRandom.random(min: enemyNode.size.width/2, max: sizeScreen.width - enemyNode.size.width/2)
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
        
        enemyNode.texture = textureAtlas.textureNamed(texture)
        enemyNode.position = initPosition
        enemyNode.size = size
        enemyNode.name = typeName
        enemyNode.zPosition = 50
        
        // Add the enemy to the scene
        self.addChild(enemyNode)
        
        
        // Apply physics
        //        enemy.physicsBody = SKPhysicsBody(texture: enemy.texture!, size: enemy.size)
        enemyNode.physicsBody = SKPhysicsBody(circleOfRadius: enemyNode.size.width / 2)
        enemyNode.physicsBody?.dynamic = true
        enemyNode.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        enemyNode.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // Create the actions
        enemyNode.runAction(SKAction.moveTo(CGPoint(x: sizeScreen.width/2, y: sizeScreen.height/2), duration: NSTimeInterval(speed)))
        
        
        // Add dots after the enemy with the correct colour
        // addEmitter(texture)
        
    }
    
    func addEmitter(texture: String) {
        
        let textureColor = self.bubbleColor(texture)
        let dotEmitter = SKEmitterNode(fileNamed: "FoodPath.sks")
        dotEmitter!.particleTexture = SKTexture(imageNamed: textureColor)
        dotEmitter!.targetNode = self
        enemyNode.addChild(dotEmitter!)
        
    }
    
    
    // TODO: Merge with other BubbleColor in own class
    func bubbleColor(type: String) -> String {
        
        switch type {
        case "Donut":
            return "bubblePink"
        case "Scoop":
            return "bubbleYellow"
        default:
            return "bubblePink"
        }
    }
    //
    
    func enemySize(type: EnemyType) -> CGSize {
        
        var sizeEnemy: CGSize
        
        switch type {
        case .Donut:
            sizeEnemy = EnemyType.Donut.spec.size
        case .Apple:
            sizeEnemy = EnemyType.Apple.spec.size
        case .Cookie:
            sizeEnemy = EnemyType.Cookie.spec.size
        case .Scoop:
            sizeEnemy = EnemyType.Scoop.spec.size
        case .Lollipop:
            sizeEnemy = EnemyType.Lollipop.spec.size
        }
        return sizeEnemy
    }
    
    
    
    func enemyTexture(type: EnemyType) -> String {
        
        var textureEnemy: String
        
        switch type {
        case .Donut:
            textureEnemy = EnemyType.Donut.spec.color
        case .Apple:
            textureEnemy = EnemyType.Apple.spec.color
        case .Cookie:
            textureEnemy = EnemyType.Cookie.spec.color
        case .Scoop:
            textureEnemy = EnemyType.Scoop.spec.color
        case .Lollipop:
            textureEnemy = EnemyType.Lollipop.spec.color
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

















