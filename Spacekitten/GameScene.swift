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
}

extension Array {
    func sample() -> Element {
        let randomIndex = Int(arc4random()) % count
        return self[randomIndex]
    }
}



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Set up Player and HUD
    let player = Player()
    let hud = HUD()
    let level = Level()
    var gameOver = false
    
    var enemyArray = [Enemy]()
    
    // Game Statistics
    var enemiesDestroyed = 0
    
    
    override func didMoveToView(view: SKView) {
        
        // Set level to 1 
        level.levelValue = 1
        
        // Background
        backgroundColor = SKColor.blackColor()
        
        //Define Player        
        player.definePlayer(sizeScreen: self.size)
        player.updatePlayerPhysics()
        self.addChild(player)
        
        // HUD
        hud.createHudNodes(self.size)
        self.addChild(hud)
        hud.zPosition = 50
        
        // Get highscore
        hud.updateHighScore()        
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        // Game starts
        self.hud.showLevel(level.levelValue)
        
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
                                                        
                            enemy.defineEnemySpecFor(self.level.levelValue, sizeScreen: self.size)
                            
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
            hud.checkIfNewHighScore(enemiesDestroyed)
            
            player.die(self.size)
            
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
            
            // If the user touches an enemy
            
            if let nodeTouchedAsSKSpriteNode: SKSpriteNode = (nodeTouched as? SKSpriteNode)! {
                self.enemyDie(nodeTouchedAsSKSpriteNode)
                
                
                let damagePotential = self.enemyDamage(nodeTouched.name!)
                enemiesDestroyed += (damagePotential / 10)
                
                let levelNew = level.checkLevel(enemiesDestroyed, currentLevel: level.levelValue)
                
                if levelNew != level.levelValue {
                    self.hud.showLevel(levelNew)
                    level.levelValue = levelNew
                }
                
                hud.setCoinCounDisplay(enemiesDestroyed)
            }
        }
    }

    
    func enemyDidCollideWithPlayer(enemy enemy:SKSpriteNode, playerHit:SKSpriteNode) {
        
        // TODO: enemy animation fade out or similar
        
        // Remove enemy from view
        enemy.removeFromParent()
        
        // Get enemy type to check damage
        let damagePotential = self.enemyDamage(enemy.name!)
        
        // Update player
        player.updatePlayerPhysics()
        player.growPlayerWhenHit(damagePotential, sizeScreen: self.size)
        
        // Get enemy type to check bubble color
        let bubbleColor = self.bubbleColor(enemy.name!)
        
        // Add 3 bubbles to the eating action
        addBubbles(bubbleColor)
        
    }
    
    func addBubbles(color: String) {
        
        var index = 0
        while index <= 2 {
            
            let bubbles = Bubble()
            bubbles.addBubbles(self.size, texture: color)
            self.addChild(bubbles)
            
            index += 1
        }
        
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
        
        switch type {
        case "Donut":
            return 10
        case "Scoop":
            return 20
        default:
            return 0
        }
    }
    
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
    
    func enemySquish(type: String) -> String {
        
        switch type {
        case "Donut":
            return "Donut-squished"
        case "Scoop":
            return "Scoop-squished"
        default:
            return "Donut-squished"
        }
    }
    
    
    func enemyDie(enemy: SKSpriteNode) {
        
        let whichEnemyShouldBeSquished = enemySquish(enemy.name!)
        
        var actions = Array<SKAction>();
        
        actions.append(SKAction.scaleTo(1.1, duration: 0.2))
        actions.append(SKAction.runBlock({enemy.texture = SKTexture(imageNamed: whichEnemyShouldBeSquished)}))
        
        enemy.removeAllActions()
        enemy.runAction(SKAction.sequence([
            SKAction.group(actions),
            SKAction.waitForDuration(0.5),
            SKAction.fadeAlphaTo(0, duration: 0.9)
        ]))
        
    }
    
}
















