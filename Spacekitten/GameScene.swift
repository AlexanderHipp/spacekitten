//
//  GameScene.swift
//  SpriteKitEasyGame
//
//  Created by Alexander Hipp on 19/06/16.
//  Copyright (c) 2016 LonelyGoldfish. All rights reserved.
//

import SpriteKit

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Player    : UInt32 = 0b1      // 1
    static let Monster   : UInt32 = 0b10     // 2
    static let Projectile: UInt32 = 0b11     // 3
}


extension Array {
    func sample() -> Element {
        let randomIndex = Int(rand()) % count
        return self[randomIndex]
    }
}



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed: "red")
    
    var monstersDestroyed = 0
    var playerSize = 20
    
    override func didMoveToView(view: SKView) {
        
        backgroundColor = SKColor.blackColor()
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        player.size = CGSize(width: playerSize, height: playerSize)
        
       updatePlayerPhysics()
        
        addChild(player)
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addMonster),
                SKAction.runBlock(checkGameOver),
                // Time after a new monster is displayed
                SKAction.waitForDuration(1.0)
                ])
            ))
    }
    
    func updatePlayerPhysics() {
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.dynamic = false
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        player.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func checkGameOver() {
        if (player.size.height >= size.height/2) && (player.size.width >= size.width/2) {
            print("Game over")
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    func addMonster() {
        
        // Create sprite
        let monster = SKSpriteNode(imageNamed: "blue")
        
        
        // Position the monster
        
        // Determine where to spawn the monster along the Y axis, left or right
        let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
        let leftSide = -monster.size.width/2
        let rightSide = size.width + monster.size.width/2
        let actualSideLeftRight = [leftSide, rightSide]
        
        // left or right
        let positionLeftRight = CGPoint(x: actualSideLeftRight.sample(), y: actualY)
        
        // Determine where to spawn the monster along the x axis, bottom or top
        let actualX = random(min: monster.size.width/2, max: size.width - monster.size.width/2)
        let bottomSide = -monster.size.height/2
        let topSide = size.height + monster.size.height/2
        let actualSideBottomTop = [bottomSide, topSide]
        
        // bottom or top
        let positionBottomTop = CGPoint(x: actualX, y: actualSideBottomTop.sample())
        
        // Choose random side
        let leftRightBottomTop = [positionLeftRight, positionBottomTop]
        monster.position = leftRightBottomTop.sample()
        
        
        // Size of enemy
        let sizeEnemy = random(min: CGFloat(7.0), max: CGFloat(20.0))
        monster.size = CGSize(width: sizeEnemy, height: sizeEnemy)
        
        
        // Add the monster to the scene
        addChild(monster)
        
        monster.physicsBody = SKPhysicsBody(rectangleOfSize: monster.size)
        monster.physicsBody?.dynamic = true
        monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        monster.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // Determine speed of the monster
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(10.0))
        
        
        // Create the actions
        monster.runAction(SKAction.moveTo(CGPoint(x: size.width/2, y: size.height/2), duration: NSTimeInterval(actualDuration)))
        
        
        
        
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        
        // 2 - Set up initial location of projectile
        let projectile = SKSpriteNode(imageNamed: "red")
        projectile.position = player.position
        projectile.size = CGSize(width: 10, height: 10)
        
        // 3 - Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        // 5 - OK to add now - you've double checked position
        addChild(projectile)
        
        // 6 - Get the direction of where to shoot
        let direction = offset.normalized()
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.dynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        // 9 - Create the actions
        let actionMove = SKAction.moveTo(realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    
    func projectileDidCollideWithMonster(projectile:SKSpriteNode, monster:SKSpriteNode) {
        // TODO: GameStats +1
        projectile.removeFromParent()
        monster.removeFromParent()
        monstersDestroyed += 1
        if (monstersDestroyed > 50) {
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let gameOverScene = GameOverScene(size: self.size, won: true)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    func enemyDidCollideWithPlayer(monster:SKSpriteNode, player:SKSpriteNode) {
        
        monster.removeFromParent()
        updatePlayerPhysics()
        playerSize += 5
        player.size = CGSize(width: playerSize, height: playerSize)
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var hitBody: SKPhysicsBody
        var destructingBody: SKPhysicsBody
        
        // A: Grow goal because it gets hit by an enemy
        if (contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2) ||
            (contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 1) {
            hitBody = contact.bodyA
            destructingBody = contact.bodyB
            
            if ((destructingBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
                (hitBody.categoryBitMask & PhysicsCategory.Player != 0)) {
                enemyDidCollideWithPlayer(destructingBody.node as! SKSpriteNode, player: hitBody.node as! SKSpriteNode)
            }
            
        // B: Delete enemy because it was hit by a missile
        } else if (contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 3) ||
            (contact.bodyA.categoryBitMask == 3 && contact.bodyB.categoryBitMask == 2) {
            hitBody = contact.bodyA
            destructingBody = contact.bodyB
            
            if ((hitBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
                (destructingBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
                projectileDidCollideWithMonster(hitBody.node as! SKSpriteNode, monster: destructingBody.node as! SKSpriteNode)
            }
            
        // Do nothing
        } else {
            // Nothing
        }
   
    }
    
}