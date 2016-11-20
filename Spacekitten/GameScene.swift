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
    let life = Life()
    var gameOver = false
    var lifeCount = 0
    
    var enemyArray = [Enemy]()
    var timeBetweenEnemies = 1.0
    
    // Game Statistics
    var enemiesDestroyed = 0
    
    var background = SKSpriteNode(imageNamed: "background")
    
    
    override func didMoveToView(view: SKView) {
        // SHow outlines
//        view.showsPhysics = true
        
        // Set level to 1 
        level.levelValue = 1
        
        // Background
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.zPosition = 0
        addChild(background)
        
        // Initiate Player
        initPlayer()
        
        // HUD
        lifeCount = life.getCurrentLifeCount()
        hud.createHudNodes(self.size, lifeCount: lifeCount)
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
                            
                            // Add enemy to array which is needed to delete all enemies if the player dies
                            self.enemyArray.append(enemy)
                            
                        }
                        
                        // Function that checks which current level the user is in and spawns the enemz accordingly
                        self.timeBetweenEnemies = self.level.getWaitingTimeDependentOnLevel(self.level.levelValue)
                        
                    }),
                    
                    // Time after a new enemy is displayed
                    SKAction.waitForDuration(self.timeBetweenEnemies)
                    
                    
                ])
            ),
            withKey: "GameOver"
        )            
        
    }
    
    func checkGameOver() {
        
        if (player.heightOfPlayer() >= size.height) || (player.widthOfPlayer() >= size.width) {
                        
            self.gameOver = true
            
            // Animation Plazer dies
            player.die(self.size)
            
            // Minimize LifeCount and update hud
            let newLifeCount = self.lifeCount - 1
            hud.setHealthDisplay(newLifeCount)
            
            // Show normal elements
            hud.showMenuButtons(self.size)
            
            // Check if Gameover and choose button accordingly
            if checkLifeCountForGameover(newLifeCount) == true {
                
                // Show GameOver Screen
                hud.showGameOverButton()
                
            } else {
                
                // Show normal restart game menu
                hud.showRestartGameButton()
                
            }
            
            // Check if new highScore and lifeCount, if yes write it in the plist
            hud.checkIfNewHighScore(enemiesDestroyed, screenSize: self.size)
            life.updateLifeScore(newLifeCount)

        }
    }
    
    
    func checkLifeCountForGameover(lifeCount: Int) -> Bool {
        
        if lifeCount <= 0 {
            return true
        } else {
            return false
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
        if (nodeTouched.name == "DonutRestart") {
            
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
        } else if (nodeTouched.name == "GoToUpsell") {            
            
            // Hide elements and show the upsell page
            background.runAction(SKAction.fadeAlphaTo(0, duration: 0.3))
            player.runAction(SKAction.fadeAlphaTo(0, duration: 0.3))
            backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
            hud.showUpsell(self.size)
            
        } else if (nodeTouched.name == "UpsellConfirmation") {
            
            // Adapt the hud elements to the new situation
            life.resetLifeCount()
            hud.hideUpsell(self.size)
            hud.showRestartGameButton()
            
            background.runAction(SKAction.fadeAlphaTo(1, duration: 0.3))
            player.runAction(SKAction.fadeAlphaTo(1, duration: 0.3))
            
            
        } else if (nodeTouched.physicsBody?.categoryBitMask == PhysicsCategory.Enemy)        {
            
            // If the user touches an enemy
            
            if let nodeTouchedAsSKSpriteNode: SKSpriteNode = (nodeTouched as? SKSpriteNode)! {
                self.enemyDie(nodeTouchedAsSKSpriteNode)
                
                let damagePotential = self.enemyDamage(nodeTouched.name!)
                
                enemiesDestroyed += checkGoodEnemy(damagePotential)
                
                let levelNew = level.checkLevel(enemiesDestroyed, currentLevel: level.levelValue)
                
                if levelNew != level.levelValue {
                    self.hud.showLevel(levelNew)
                    level.levelValue = levelNew
                }
                
                hud.setCoinCounDisplay(enemiesDestroyed)
            }
        }
    }
    
    func checkGoodEnemy(potential: Int) -> Int {
        
        var potentialAfterCheck = 0
        
        if potential < 0 {
            potentialAfterCheck = potential * -2
        } else {
            potentialAfterCheck = potential
        }
        
        return potentialAfterCheck / 10
        
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
            return 150
        case "Apple":
            return -10
        case "Cookie":
            return 30
        case "Scoop":
            return 50
        case "Lollipop":
            return 70
        default:
            return 0
        }
    }
    
    // Merge with other bubbleColor in Enemy.swift
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
        
        actions.append(SKAction.scaleTo(1.1, duration: 0.1))
        
        enemy.texture = SKTexture(imageNamed: whichEnemyShouldBeSquished)
        enemy.removeAllActions()
        enemy.runAction(SKAction.sequence([
            SKAction.group(actions),
            SKAction.waitForDuration(0.7),
            SKAction.fadeAlphaTo(0, duration: 2.0)
        ]))
        enemy.removeAllChildren()
        
    }
    
    func initPlayer() {
        
        //Define Player
        player.definePlayer(sizeScreen: self.size)
        player.updatePlayerPhysics()
        self.addChild(player)
        
        // Set initial player size
        player.initialPlayerSize = player.playerSize
        
    }
}
















