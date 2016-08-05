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
    var gameOver = false
    
    var enemyArray = [Enemy]()
    
    // Game Statistics
    var enemiesDestroyed = 0
    
    
    override func didMoveToView(view: SKView) {
        
    
        
        // Background
        backgroundColor = SKColor.blackColor()
        
        //Define Player        
        player.definePlayer(self.size)
        player.updatePlayerPhysics()
        self.addChild(player)
        
        // HUD
        hud.createHudNodes(self.size)
        self.addChild(hud)
        hud.zPosition = 50
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        runAction(
            SKAction.repeatActionForever (
                SKAction.sequence([
                    SKAction.runBlock({
                        
                        // Check if game over
                        if self.gameOver == true {
                            self.removeActionForKey("GameOver")
                        } else {
                            self.checkGameOver()
                        }
                        
                    }),
                    SKAction.runBlock({
                        
                        let enemy = Enemy()
                        
                        // Check if game over
                        if self.gameOver == true {
                            self.removeAllEnemyNodes()
                        } else {
                            
                            // Init and add the projectile
                            enemy.defineEnemySpecFor(.Taubsi, sizeScreen: self.size)
                            
                            self.addChild(enemy)
                            
                            // Add enemy to array
                            self.enemyArray.append(enemy)
                            
                        }
                        
                    }),
                    
                    // Time after a new enemy is displayed
                    SKAction.waitForDuration(0.5)
                    
                ])
            ),
            withKey: "GameOver"
        )
        
    }
    
    func checkGameOver() {
        if (player.heightOfPlayer() >= size.height / 2) && (player.widthOfPlayer() >= size.width / 2) {
                        
            self.gameOver = true
            player.removeFromParent()
            player.die()
            
            hud.showButtons(self.size)
            
            // Background
            backgroundColor = UIColor(red:0.19, green:0.21, blue:0.24, alpha:1.0)
            

        }
    }
    
    
    func removeAllEnemyNodes()  {
        // Go through the enemyArray and delete all enemy nodes from the game
        for i in 0 ..< self.enemyArray.count  {
            self.enemyArray[i].removeFromParent()
        }
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        let nodeTouched = nodeAtPoint(touchLocation)
        
        
        // Check for HUD buttons:
        if nodeTouched.name == "restartButton" {
            self.view?.presentScene(
                GameScene(size: self.size),
                transition: .crossFadeWithDuration(0.6)
            )
        } else if nodeTouched.name == "returnToMenu" {
            self.view?.presentScene(
                MenuScene(size: self.size),
                transition: .crossFadeWithDuration(0.6)
            )
        } else {
            
            // Init and add the projectile
            let projectile = Projectile()
            projectile.createProjectile(touchLocation, playerPosition: player.positionPlayer(size))
            self.addChild(projectile)
            
        }
        
    }
    

    func projectileDidCollideWithEnemy(projectile projectile:SKSpriteNode, enemy:SKSpriteNode) {
        projectile.removeFromParent()
        enemy.removeFromParent()
        enemiesDestroyed += 1
        hud.setCoinCounDisplay(enemiesDestroyed)
    }

    
    func enemyDidCollideWithPlayer(enemy enemy:SKSpriteNode, playerHit:SKSpriteNode) {
        
        enemy.removeFromParent()
        
        // Get enemy type to check damage
        let damagePotential = self.enemyDamage(enemy.name!)
        
        player.updatePlayerPhysics()
        player.growPlayerWhenHit(damagePotential)
        
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
    
    
    func enemyDamage(type: String) -> Int {
        
        var damageEnemy: Int
        
        switch type {
        case "Taubsi":
            damageEnemy = 25
        case "Pikachu":
            damageEnemy = 5
        case "Relaxo":
            damageEnemy = 10
        default:
            damageEnemy = 0
        }
        return damageEnemy
        
    }
    
}