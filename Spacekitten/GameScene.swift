//
//  GameScene.swift
//  Spacekitten
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
    static let Player    : UInt32 = 0b1      // value 1
    static let Enemy     : UInt32 = 0b10     // value 2
    static let Projectile: UInt32 = 0b11     // value 3
}


extension Array {
    func sample() -> Element {
        let randomIndex = Int(rand()) % count
        return self[randomIndex]
    }
}



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed: "red")
    let hud = HUD()
    
    
    var enemiesDestroyed = 0
    var playerSize = 120
    
    override func didMoveToView(view: SKView) {
        
        backgroundColor = SKColor.blackColor()
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        player.size = CGSize(width: playerSize, height: playerSize)
        player.zPosition = 13
        
        updatePlayerPhysics()
        
        addChild(player)
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addEnemy),
                SKAction.runBlock(checkGameOver),
                // Time after a new enemy is displayed
                SKAction.waitForDuration(0.5)
                ])
            ))
        
        // HUD
        hud.createHudNodes(self.size)
        self.addChild(hud)
        hud.zPosition = 50
    }
    
    func updatePlayerPhysics() {
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.dynamic = false
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
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
            if let gameScene = self.parent?.parent as? GameScene {
                gameScene.gameOver()
            }
//            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
//            let gameOverScene = GameOverScene(size: self.size, won: false)
//            self.view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    
    let colorEnemy:[String] = ["blue", "yellow", "green", "orange", "purple"]
    
    func addEnemy() {
        
        let currentColor = colorEnemy.sample()
        
        // Create sprite
        let enemy = SKSpriteNode(imageNamed: currentColor)
        
        
        // Position the enemy
        
        // Determine where to spawn the enemy along the Y axis, left or right
        let actualY = random(min: enemy.size.height/2, max: size.height - enemy.size.height/2)
        let leftSide = -enemy.size.width/2
        let rightSide = size.width + enemy.size.width/2
        let actualSideLeftRight = [leftSide, rightSide]
        
        // left or right
        let positionLeftRight = CGPoint(x: actualSideLeftRight.sample(), y: actualY)
        
        // Determine where to spawn the enemy along the x axis, bottom or top
        let actualX = random(min: enemy.size.width/2, max: size.width - enemy.size.width/2)
        let bottomSide = -enemy.size.height/2
        let topSide = size.height + enemy.size.height/2
        let actualSideBottomTop = [bottomSide, topSide]
        
        // bottom or top
        let positionBottomTop = CGPoint(x: actualX, y: actualSideBottomTop.sample())
        
        // Choose random side
        let leftRightBottomTop = [positionLeftRight, positionBottomTop]
        enemy.position = leftRightBottomTop.sample()
        
        
        // Size of enemy
        let sizeEnemy = random(min: CGFloat(7.0), max: CGFloat(20.0))
        enemy.size = CGSize(width: sizeEnemy, height: sizeEnemy)
        
        
        // Add the enemy to the scene
        addChild(enemy)
        
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        enemy.physicsBody?.dynamic = true
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        enemy.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // Determine speed of the enemy
        let actualDuration = random(min: CGFloat(1.0), max: CGFloat(8.0))
        
        
        // Create the actions
        enemy.runAction(SKAction.moveTo(CGPoint(x: size.width/2, y: size.height/2), duration: NSTimeInterval(actualDuration)))
        
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        
        // Init and add the projectile
        let projectile = Projectile()
        projectile.createProjectile(touchLocation, playerPosition: player.position)
        self.addChild(projectile)
        
    }
    
    
    func gameOver() {        
        hud.showButtons()
    }
    
    func projectileDidCollideWithEnemy(projectile projectile:SKSpriteNode, enemy:SKSpriteNode) {
        projectile.removeFromParent()
        enemy.removeFromParent()
        enemiesDestroyed += 1
        hud.setCoinCounDisplay(enemiesDestroyed)
        if (enemiesDestroyed > 5) {
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let gameOverScene = GameOverScene(size: self.size, won: true)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
    }

    
    func enemyDidCollideWithPlayer(enemy enemy:SKSpriteNode, player:SKSpriteNode) {
        
        enemy.removeFromParent()
        updatePlayerPhysics()
        playerSize += 25
        player.size = CGSize(width: playerSize, height: playerSize)
    }
    
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var hitBody: SKPhysicsBody
        var destructingBody: SKPhysicsBody
        
        // A: Grow player because it gets hit by an enemy
        if (contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2) ||
            (contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 1) {
            hitBody = contact.bodyA
            destructingBody = contact.bodyB
            
            if ((destructingBody.categoryBitMask & PhysicsCategory.Enemy != 0) &&
                (hitBody.categoryBitMask & PhysicsCategory.Player != 0)) {
                
                // Check if both hit bodies are not null and than do the function
                if let bodyAAC = destructingBody.node as? SKSpriteNode {
                    if let bodyAAB = hitBody.node as? SKSpriteNode {
                        enemyDidCollideWithPlayer(enemy: bodyAAC, player: bodyAAB)
                    }
                }
            }
            
            
        // B: Delete enemy because it was hit by a projectile
        } else if (contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 3) ||
            (contact.bodyA.categoryBitMask == 3 && contact.bodyB.categoryBitMask == 2) {
            hitBody = contact.bodyA
            destructingBody = contact.bodyB
            
            if ((hitBody.categoryBitMask & PhysicsCategory.Enemy != 0) &&
                (destructingBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
                
                if let bodyAAD = destructingBody.node as? SKSpriteNode {
                    if let bodyAAE = hitBody.node as? SKSpriteNode {
                        projectileDidCollideWithEnemy(projectile: bodyAAE, enemy: bodyAAD)
                    }
                }
            }
            
        // Do nothing
        } else {
            // Nothing
        }
   
    }
    
}