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
    var level = 1
    let highScore = "highScore"
    
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
        
        // Get highscore
        updateHighScore()
        
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        // Game starts
        self.hud.showLevel(level)        
        
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
                    SKAction.waitForDuration(1.0)
                    
                ])
            ),
            withKey: "GameOver"
        )
        
    }
    
    func checkGameOver() {
        if (player.heightOfPlayer() >= size.height) || (player.widthOfPlayer() >= size.width) {
                        
            self.gameOver = true
            
            // Check if new highScore, if yes write it in the plist
            checkIfNewHighScore(enemiesDestroyed)
            
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
        
        
        // Check for HUD donut:
        if nodeTouched.name == "DonutRestart" {
            
            runAction(
                SKAction.sequence([
                    SKAction.runBlock({
                        self.hud.squishHUDDonut()
                    }),
                    SKAction.runBlock({
                        self.hud.fadeOutHUDelements()
                    }),
                    SKAction.waitForDuration(0.9),
                    SKAction.runBlock({
                        self.view?.presentScene(GameScene(size: self.size), transition: .crossFadeWithDuration(0.9))
                    })
                ])
            )                                
            
        } else if (nodeTouched.physicsBody?.categoryBitMask == PhysicsCategory.Enemy)        {
            
            if let nodeTouchedAsSKSpriteNode: SKSpriteNode = (nodeTouched as? SKSpriteNode)! {
                self.enemyDie(nodeTouchedAsSKSpriteNode)
                enemiesDestroyed += 1
                
                
                let levelNew = checkLevel(enemiesDestroyed, currentLevel: level)
                
                if levelNew != level {
                    self.hud.showLevel(levelNew)
                    level = levelNew
                }
                
                hud.setCoinCounDisplay(enemiesDestroyed)
            }
        }
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
    
    func enemyDie(enemy: SKSpriteNode) {
        
        var actions = Array<SKAction>();
        
        actions.append(SKAction.scaleTo(1.4, duration: 0.5))
        actions.append(SKAction.runBlock({enemy.texture = SKTexture(imageNamed: "Donut-squished")}))
        
        enemy.removeAllActions()
        enemy.runAction(SKAction.sequence([
            SKAction.group(actions),
            SKAction.waitForDuration(1.2),
            SKAction.fadeAlphaTo(0, duration: 0.9)
        ]))
        
    }
    
    
    func checkLevel(destroyedEnemies: Int, currentLevel: Int) -> Int {
    
        switch destroyedEnemies {
        case 0 ... 4: 
            return 1
        case 5 ... 7:
            return 2
        case 8 ... 10:
            return 3
        case 11 ... 15:
            return 4
        case 16 ... 18:
            return 5
        default:
            return currentLevel
        }
        
        
    }
    
    func updateHighScore() {
        
        if let highScoreValue = PlistManager.sharedInstance.getValueForKey(highScore) {
            self.hud.coinCountBest.text = "\(highScoreValue)"
        } else {
            self.hud.coinCountBest.text = "0"
        }
        
    }
    
    func checkIfNewHighScore(newHighScore: Int) {
        
        let oldHighScoreValue: Int = PlistManager.sharedInstance.getValueForKey(highScore) as! Int
        
        if newHighScore > oldHighScoreValue {
            PlistManager.sharedInstance.saveValue(newHighScore, forKey: highScore)
            updateHighScore()
        }
        
    }
    
}
















