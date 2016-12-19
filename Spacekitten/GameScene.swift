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
    let p = Premium()
    
    var gameLost = false
    
    var enemyArray = [Enemy]()
    var timeBetweenEnemies = 0.7
    
    // Game Statistics
    var enemiesDestroyed = 0
    
    var background = SKSpriteNode(imageNamed: "Mountains")
    
    
    override func didMoveToView(view: SKView) {
        
        // Check if timer is running and if user if premium
        
        print("This user has the premium membership:", p.checkIfUserIsPremium())        
        
        hud.notPremiumAndTimerRunning()
        
        // Show outlines
        // view.showsPhysics = true
        
        // Set level to 1 
        level.levelValue = 1
        
        // Background
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.zPosition = 0
        addChild(background)
        
        // Initiate Player
        initPlayer()
        
        // HUD
        hud.createHudNodes(self.size)
        self.addChild(hud)
        hud.zPosition = 50
        
        // Get highscore
        hud.updateHighScore()        
        
        // Physics World settings
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        // Show start menu items
        hud.logoShow()
        hud.menuButtonShow()
        print("Show start menu")
        
    }
    
    func checkGameLost() {
        
        if (player.heightOfPlayer() >= size.height) || (player.widthOfPlayer() >= size.width) {
            
            self.removeAllEnemyNodes()
            self.gameLost = true
            
            // Animation Player dies
            player.die(self.size)
            
            // Check if new highScore and lifeCount, if yes write it in the plist
            let newHighscore = hud.checkIfNewHighScore(enemiesDestroyed)
            
            // Minimize LifeCount and update hud
            let newLifeCount = life.decreaseLifeCount(newHighscore)
            life.updateLifeScore(newLifeCount)
            
            // If no lifes left the timer should fire but only if the user is not premium
            startTimerIfNeeded()
            
            // Show normal elements
            hud.menuItemsShow(newHighscore)
            
        }
    }
    
    func startTimerIfNeeded(){
        
        if (p.checkIfUserIsPremium() == false) && (life.checkLifeCountForGameover() == true) && (hud.checkIfTimerIsRunning() == false) {
            hud.setEndTimePList()
            hud.startTimer()
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
        if (nodeTouched.name == "StartGame") {
            
            print(life.getCurrentLifeCount())
            print("Game started")
            
            runAction(
                SKAction.sequence([
                    SKAction.runBlock({
                        self.hud.squishHUDDonut()
                        self.hud.logoHide()
                        self.hud.menuButtonHide()
                        self.hud.menuItemsAfterPurchaseHide()
                        self.hud.gameItemsShow()
                    }),
                    SKAction.runBlock({
                        self.level.levelValue = 1
                        self.enemiesDestroyed = 0
                        self.hud.coinCountText.text = "0"
                        self.hud.showLevel(self.level.levelValue)
                    }),
                    SKAction.waitForDuration(0.2),
                    SKAction.runBlock({
                        print("Before Loop")
                        self.gameLost = false
                        self.gameLoop()
                        print("After Loop")
                    }),
                    SKAction.runBlock({
                        self.hud.unSquishHUDDonut()
                    })
                ])
            )
        } else if (nodeTouched.name == "GoToUpsell") {            
            
            hud.upsellPageShow()
            
        } else if (nodeTouched.name == "UpsellConfirmation") {
            
            // MENU AFTER UPSELL
            print("menu after upsell")
            
            // Set life count back to max for now. If user is premium there is no need for this check anymore
            life.resetLifeCount()
            
            // Set premium account
            p.getPremium()
            
            print("User is now premium")
            hud.premiumLabel.text = "PREMIUM"
            
            hud.endTimer()
            hud.hideHeartItems()
            
            hud.upsellPageHide()
            hud.menuItemsAfterPurchaseShow()
            
            // Here we should check if the purchase was successful or not in an own class
            
        } else if (nodeTouched.name == "BackFromFunnelToMenu") {
            
            // MENU AFTER UPSELL
            print("menu after back from upsell")
            
            hud.upsellPageHide()
            
        } else if (nodeTouched.physicsBody?.categoryBitMask == PhysicsCategory.Enemy)        {
            
            // If the user touches an enemy
            
            if let nodeTouchedAsSKSpriteNode: SKSpriteNode = (nodeTouched as? SKSpriteNode)! {
                self.enemyDie(nodeTouchedAsSKSpriteNode)
                
                let damagePotential = self.enemyDamage(nodeTouched.name!)
                
                enemiesDestroyed += calculatePotential(damagePotential)
                
                let levelNew = level.checkLevel(enemiesDestroyed, currentLevel: level.levelValue)
                
                if levelNew != level.levelValue {
                    self.hud.showLevel(levelNew)
                    level.levelValue = levelNew
                }
                
                // Update counter in the game
                hud.setCoinCounDisplay(enemiesDestroyed)
            }
        }
    }
    
    func calculatePotential(potential: Int) -> Int {
        return (potential / 10)
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
            return 15
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
            return "Eat_Dot_Donut"
        case "Apple":
            return "Eat_Dot_Apple"
        case "Cookie":
            return "Eat_Dot_Cookie"
        case "Scoop":
            return "Eat_Dot_Scoop"
        case "Lollipop":
            return "Eat_Dot_Lollipop"
        default:
            return "Eat_Dot_Donut"
        }
    }
    //
    
    func enemySquish(type: String) -> String {
        
        switch type {
        case "Donut":
            return "Donut-squished"
        case "Apple":
            return "Apple-squished"
        case "Cookie":
            return "Cookie-squished"
        case "Scoop":
            return "Scoop-squished"
        case "Lollipop":
            return "Lollipop-squished"
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
            SKAction.waitForDuration(0.4),
            SKAction.fadeAlphaTo(0, duration: 0.5)
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
    
    
    func gameLoop() {
        
        print("Inside Loop Start")
        
        var index = 1
        
        runAction(
            SKAction.repeatActionForever (
                SKAction.sequence([
                    SKAction.runBlock({
                        
                        print("Loop Round", index)
                        index = index + 1
                        
                        // Check if game over
                        if self.gameLost == true {
                            print("Game over")
                            self.removeActionForKey("GameLost")
                        } else {
                            self.checkGameLost()
                        }
                        
                    }),
                    SKAction.runBlock({
                        
                        let enemy = Enemy()
                        
                        // Check if game lost
                        if self.gameLost != true {
                            
                            enemy.defineEnemySpecFor(self.level.levelValue, sizeScreen: self.size)
                            self.addChild(enemy)
                            
                            // Add enemy to array which is needed to delete all enemies if the player dies
                            self.enemyArray.append(enemy)
                            
                        }
                        
                        // Function that checks which current level the user is in and spawns the enemy accordingly
                        self.timeBetweenEnemies = self.level.getWaitingTimeDependentOnLevel(self.level.levelValue)
                        
                    }),
                    
                    // Time after a new enemy is displayed
                    SKAction.waitForDuration(self.timeBetweenEnemies)
                    
                    
                    ])                
            ),
            withKey: "GameLost"
        )
    }
}
















