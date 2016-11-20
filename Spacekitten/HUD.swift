//
//  HUD.swift
//  Spacekitten
//
//  Created by Alexander Hipp on 04/07/16.
//  Copyright © 2016 LonelyGoldfish. All rights reserved.
//

import SpriteKit

class HUD: SKNode {
    
    let life = Life()
    
    let menuButton = SKSpriteNode()
    let upsellButton = SKLabelNode(text: "Buy Fullversion")
    
    let coinCountText = SKLabelNode(text: "0")
    let labelScore = SKLabelNode(text: "Score")
    var labelBest = SKLabelNode(text: "Best")
    var coinCountBest = SKLabelNode(text: "0")
    
    let labelGameOver = SKLabelNode(text: "Game Over")
    var waitingTime = SKLabelNode(text: "Wait for 6 mins")
    
    let buyFullVersionButton = SKSpriteNode()
    
    let levelLabel = SKLabelNode(text: "Level 0")
    
    let textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "sprites.atlas")
    
    let font = "CooperHewitt-Heavy"
    let fadeInAnimation = SKAction.fadeAlphaTo(1, duration: 0.9)
    let fadeOutAnimation = SKAction.fadeAlphaTo(0, duration: 0.9)
    
    let highScore = "highScore"       
    
    // An array to keep track of the hearts
    var heartNodes: [SKSpriteNode] = []
    
    
    func createHudNodes(screenSize: CGSize, lifeCount: Int) {
        
        
        // Game Stats
        let coinXPos = screenSize.width / 2
        let coinYPos = screenSize.height - 50
        coinCountText.fontName = font
        coinCountText.position = CGPoint(x: coinXPos, y: coinYPos)
        coinCountText.fontSize = 40.0
        coinCountText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        coinCountText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        // Define center of screen for placing
        let centerOfHud = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
        
        
        // After Player dies
        
        // Donut to restart the game
        menuButton.texture = textureAtlas.textureNamed("Donut")
        menuButton.position = CGPoint(x: centerOfHud.x, y: centerOfHud.y - 200 )
        menuButton.size = CGSize(width: 100, height: 100)
        menuButton.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(-5.0, duration: 20)))
        menuButton.name = "DonutRestart"
        menuButton.alpha = 0
        
        
        // Score Label
        labelScore.position = CGPoint(x: ((screenSize.width / 2) - 80), y: ((screenSize.height / 2) + 200))
        labelScore.fontName = font
        labelScore.fontSize = 25.0
        labelScore.userInteractionEnabled = false
        labelScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        labelScore.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        labelScore.alpha = 0
        
        // Best Label
        labelBest.position = CGPoint(x: ((screenSize.width / 2) + 80), y: ((screenSize.height / 2) + 200))
        labelBest.fontName = font
        labelBest.fontSize = 25.0
        labelBest.userInteractionEnabled = false
        labelBest.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        labelBest.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        labelBest.alpha = 0
        
        
        // Count Best
        coinCountBest.position = CGPoint(x: ((screenSize.width / 2) + 80), y: ((screenSize.height / 2) + 150))
        coinCountBest.fontName = font
        coinCountBest.fontSize = 40.0
        coinCountBest.userInteractionEnabled = false
        coinCountBest.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        coinCountBest.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        coinCountBest.fontColor = UIColor(red:0.95, green:0.36, blue:0.26, alpha:1.0)
        coinCountBest.alpha = 0
        
        
        // Level Label 
        levelLabel.position = CGPoint(x: centerOfHud.x, y: centerOfHud.y - 250 )
        levelLabel.fontName = font
        levelLabel.fontSize = 40.0
        levelLabel.zPosition = 40
        levelLabel.userInteractionEnabled = false
        levelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        levelLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        levelLabel.fontColor = UIColor(red:0.95, green:0.36, blue:0.26, alpha:1.0)
        
        
        // Nodes for Game Over Display
        
        // Game Over Label
        labelGameOver.position = CGPoint(x: (screenSize.width / 2), y: ((screenSize.height / 2) + 200))
        labelGameOver.fontName = font
        labelGameOver.fontSize = 25.0
        labelGameOver.userInteractionEnabled = false
        labelGameOver.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        labelGameOver.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        labelGameOver.alpha = 0
        
        
        // Waiting Time
        waitingTime.position = CGPoint(x: (screenSize.width / 2), y: ((screenSize.height / 2) + 150))
        waitingTime.fontName = font
        waitingTime.fontSize = 40.0
        waitingTime.userInteractionEnabled = false
        waitingTime.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        waitingTime.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        waitingTime.fontColor = UIColor(red:0.95, green:0.36, blue:0.26, alpha:1.0)
        waitingTime.alpha = 0
        
        
        // Upsell Button
        upsellButton.position = CGPoint(x: centerOfHud.x, y: centerOfHud.y - 200 )
        upsellButton.fontName = font
        upsellButton.fontSize = 40.0
        upsellButton.userInteractionEnabled = false
        upsellButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        upsellButton.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        upsellButton.fontColor = UIColor(red:0.95, green:0.36, blue:0.26, alpha:1.0)
        upsellButton.name = "UpsellConfirmation"
        upsellButton.alpha = 0
        
        
        // Apply all nodes to HUD
        
        self.addChild(levelLabel)
        self.addChild(labelScore)
        self.addChild(labelBest)
        self.addChild(labelGameOver)
        
        self.addChild(coinCountText)
        self.addChild(coinCountBest)
        self.addChild(waitingTime)
        
        self.addChild(menuButton)
        self.addChild(upsellButton)
        
        
        // Create heart nodes for the life meter
        for index in 0 ..< life.maxLifeCount {
            let newHeartNode = SKSpriteNode(texture:textureAtlas.textureNamed("Apple"))
            newHeartNode.size = CGSize(width: 25, height: 25)
            let xPos = CGFloat(index * 40 + 20)
            let yPos = screenSize.height - 30
            newHeartNode.position = CGPoint(x: xPos, y: yPos)
            
            heartNodes.append(newHeartNode)
            self.addChild(newHeartNode)
        }
        
        // Update the lifeCount Display
        setHealthDisplay(lifeCount)
        
    }
    
    func setCoinCounDisplay(newCoinCount: Int) {
        
        let formatter = NSNumberFormatter()
        formatter.minimumIntegerDigits = 1
        if let coinStr = formatter.stringFromNumber(newCoinCount) {
            coinCountText.text = coinStr
        }
        
    }
    
    func squishHUDDonut() {
        
        menuButton.texture = SKTexture(imageNamed: "Donut-squished")
        menuButton.size = CGSize(width: 60, height: 60)
        
    }
    
    func showMenuButtons(screenSize: CGSize) {
        
        // TODO make func for alpha add child and fade animation
        menuButton.runAction(fadeInAnimation)
        labelScore.runAction(fadeInAnimation)
        labelBest.runAction(fadeInAnimation)
        coinCountBest.runAction(fadeInAnimation)
        
        coinCountText.position = CGPoint(x: ((screenSize.width / 2) - 80), y: ((screenSize.height / 2) + 150))
        coinCountText.fontColor = UIColor(red:0.00, green:0.75, blue:0.69, alpha:1.0)
        
    }
    
    func showGameOverButton() {
        
        menuButton.name = "GoToUpsell"
        
    }
    
    func showRestartGameButton() {
        
        menuButton.name = "DonutRestart"
        
    }
    
    func showUpsell(screenSize: CGSize) {
        
        // Fade out elements
        fadeOutHUDelements()
        for index in 0 ..< 3 {
            heartNodes[index].runAction(fadeOutAnimation)
        }
        
        // Show upsell elements
        labelGameOver.runAction(fadeInAnimation)
        waitingTime.runAction(fadeInAnimation)
        upsellButton.runAction(fadeInAnimation)
        
    }
    
    func hideUpsell(screenSize: CGSize) {
        
        // Fade in elements
        showMenuButtons(screenSize)
        setHealthDisplay(life.maxLifeCount)
        positionLabelBestCentered(screenSize)
        
        // Hide upsell elements
        labelGameOver.runAction(fadeOutAnimation)
        waitingTime.runAction(fadeOutAnimation)
        upsellButton.runAction(fadeOutAnimation)
        
    }
    
    func letItRain(screenSize: CGSize) {
        guard let emitter = SKEmitterNode(fileNamed: "NewHighscore") else {
            return
        }
        
        // Place the emitter at the rear of the ship.
        emitter.position = CGPoint(x: screenSize.width / 2, y: screenSize.height)
        emitter.particlePositionRange = CGVector(dx: screenSize.width, dy: 0.0)
        emitter.name = "NewHighscore"
        
        // Send the particles to the scene.
        emitter.targetNode = scene;
        self.addChild(emitter)
    }
    
    
    func fadeOutHUDelements() {
        menuButton.runAction(fadeOutAnimation)
        coinCountBest.runAction(fadeOutAnimation)
        labelBest.runAction(fadeOutAnimation)
        labelScore.runAction(fadeOutAnimation)
        coinCountText.runAction(fadeOutAnimation)
    }

    func showLevel(currentLevel: Int) {
        levelLabel.text = "Level \(currentLevel)"
        levelLabel.alpha = 0
        levelLabel.fontColor = colorLevelLabel[currentLevel]
        
        runAction(
            SKAction.sequence([
                SKAction.runBlock({
                    self.levelLabel.runAction(self.fadeInAnimation)
                }),
                SKAction.waitForDuration(1.0),
                SKAction.runBlock({
                    self.levelLabel.runAction(self.fadeOutAnimation)
                })
            ])
        )
    }
    
    
    // Connection to Plist for Highscore
    
    func updateHighScore() {
        
        if let highScoreValue = PlistManager.sharedInstance.getValueForKey(highScore) {
            coinCountBest.text = "\(highScoreValue)"
        } else {
            coinCountBest.text = "0"
        }
        
    }
    
    func checkIfNewHighScore(newHighScore: Int, screenSize: CGSize) {
        
        let oldHighScoreValue: Int = PlistManager.sharedInstance.getValueForKey(highScore) as! Int
        
        if newHighScore > oldHighScoreValue {
            PlistManager.sharedInstance.saveValue(newHighScore, forKey: highScore)
            updateHighScore()
            letItRain(screenSize)
            labelBest.text = "New Highscore"
            positionLabelBestCentered(screenSize)
        }
    }
    
    // If the labelBest schould be centered
    func positionLabelBestCentered(screenSize: CGSize) {
        labelBest.position = CGPoint(x: (screenSize.width / 2), y: ((screenSize.height / 2) + 200))
        coinCountBest.position = CGPoint(x: (screenSize.width / 2), y: ((screenSize.height / 2) + 150))
        coinCountText.hidden = true
        labelScore.hidden = true
    }
    
    
    func setHealthDisplay(newHealth: Int) {
        
        let fadeAction = SKAction.fadeAlphaTo(0.2, duration: 0)
        
        for index in 0 ..< life.maxLifeCount {
            if index < newHealth {
                heartNodes[index].alpha = 1
            } else {
                heartNodes[index].runAction(fadeAction)
            }
        }
    }
    
    // Colors for Level Labels
    
    let colorLevelLabel: [Int: UIColor] = [
        1: UIColor(red: 0, green: 0.7451, blue: 0.6863, alpha: 1.0), /* red #00beaf */
        2: UIColor(red: 0.9294, green: 0.8784, blue: 0.0588, alpha: 1.0), /* yellow #ede00f */
        3: UIColor(red: 0.2902, green: 0.5412, blue: 0.7843, alpha: 1.0), /* blue #4a8ac8 */
        4: UIColor(red: 0, green: 0.7451, blue: 0.6863, alpha: 1.0), /* green #00beaf */
        5: UIColor(red: 0.949, green: 0.3608, blue: 0.2627, alpha: 1.0) /* orange #f25c43 */
    ]
    
    
}














