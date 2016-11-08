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
        case Donut, Apple, Cookie, Scoop, Lollipop
        var spec: (size: CGSize, color: String, speed: CGFloat, name: String) {
            switch self {
            case Donut: return (size: CGSize(width: 60, height: 60), color: "Donut", speed: 1.0, name: "Donut")
            case Apple: return (size: CGSize(width: 60, height: 60), color: "Apple", speed: 1.0, name: "Apple")
            case Cookie: return (size: CGSize(width: 60, height: 60), color: "Cookie", speed: 1.0, name: "Cookie")
            case Scoop: return (size: CGSize(width: 60, height: 60), color: "Scoop", speed: 1.0, name: "Scoop")
            case Lollipop: return (size: CGSize(width: 60, height: 60), color: "Lollipop", speed: 2.5, name: "Lollipop")
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
        enemy.zPosition = 50
        
        // Add the enemy to the scene
        self.addChild(enemy)
        
        
        // Apply physics
//        enemy.physicsBody = SKPhysicsBody(texture: enemy.texture!, size: enemy.size)
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.size.width / 2 - 10)
        enemy.physicsBody?.dynamic = true
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy        
        enemy.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // Create the actions
        enemy.runAction(SKAction.group([
            SKAction.moveTo(CGPoint(x: sizeScreen.width/2, y: sizeScreen.height/2), duration: NSTimeInterval(speed)),
            SKAction.repeatActionForever(SKAction.rotateByAngle(-5.0, duration: 20.0))
        ]))
        
        
        // Add dots after the enemy with the correct colour
        // addEmitter(texture)
        
        
 
    }
    
    func addEmitter(texture: String) {
        
        let textureColor = self.bubbleColor(texture)
        let dotEmitter = SKEmitterNode(fileNamed: "FoodPath.sks")
        dotEmitter!.particleTexture = SKTexture(imageNamed: textureColor)
        dotEmitter!.targetNode = self
        enemy.addChild(dotEmitter!)
        
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
    
    func removeAllEnemies() {
        self.enemy.removeFromParent()
    }
    
    func whichEnemyTypeWillBeDisplayed(currentLevel: Int) -> EnemyType {
        
        switch currentLevel {
//        case 1:
//            return getPossibleEnemies([.Donut, .Apple, .Cookie, .Scoop, .Lollipop])
        default:
            return getPossibleEnemies([.Donut, .Apple])
        }
        
    }
    
    func getPossibleEnemies(enemyArray: [EnemyType]) -> EnemyType {
        let enemyToDisplay: EnemyType = enemyArray.sample()
        return enemyToDisplay
    }
    
}

















