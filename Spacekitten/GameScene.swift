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
    
    // Set up Player and HUD
    let player = Player()
    let hud = HUD()    
    
    // Game Statistics
    var enemiesDestroyed = 0
    
    
    override func didMoveToView(view: SKView) {
        
        // Background
        backgroundColor = SKColor.blackColor()
        
        //Define Player        
        player.definePlayer(self.size)
        player.updatePlayerPhysics()
        self.addChild(player)
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(placeEnemy),
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
    
    func placeEnemy() {
        
        let enemy = Enemy()
        let enemySize = enemy.giveEnemySize()
        let enemyRandomPosition = enemy.defineEnemyPosition(size, enemySize: enemySize)
        enemy.addEnemy(enemyRandomPosition, sizeScreen: size)        
        self.addChild(enemy)                
        
    }
    
    
    
    func checkGameOver() {
        if (player.heightOfPlayer() >= size.height/2) && (player.widthOfPlayer() >= size.width/2) {
            if let gameScene = self.parent?.parent as? GameScene {
                gameScene.gameOver()
            }
//            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
//            let gameOverScene = GameOverScene(size: self.size, won: false)
//            self.view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        
        // Init and add the projectile
        let projectile = Projectile()
        projectile.createProjectile(touchLocation, playerPosition: player.positionPlayer(size))
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

    
    func enemyDidCollideWithPlayer(enemy enemy:SKSpriteNode, playerHit:SKSpriteNode) {
        
        enemy.removeFromParent()
        player.updatePlayerPhysics()
        player.growPlayerWhenHit()
        
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
                        enemyDidCollideWithPlayer(enemy: bodyAAC, playerHit: bodyAAB)
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