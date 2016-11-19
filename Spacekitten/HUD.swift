//
//  HUD.swift
//  Spacekitten
//
//  Created by Alexander Hipp on 04/07/16.
//  Copyright © 2016 LonelyGoldfish. All rights reserved.
//

import SpriteKit

class HUD: SKNode {
    
    
    let ralphFace = SKSpriteNode()
    let menuButton = SKSpriteNode()
    
    let coinCountText = SKLabelNode(text: "0")
    let labelScore = SKLabelNode(text: "Score")
    var labelBest = SKLabelNode(text: "Best")
    var coinCountBest = SKLabelNode(text: "0")
    
    let levelLabel = SKLabelNode(text: "Level 0")
    
    let textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "sprites.atlas")
    
    let font = "CooperHewitt-Heavy"
    let fadeInAnimation = SKAction.fadeAlphaTo(1, duration: 0.9)
    let fadeOutAnimation = SKAction.fadeAlphaTo(0, duration: 0.9)
    
    let highScore = "highScore"
    let pListLifeCount = "pListLifeCount"
    let maxLifeCount = 3
    
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
        self.addChild(coinCountText)
        
        
        let centerOfHud = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
        
        
        // After Game over               
        
        // Donut to restart the game
        menuButton.texture = textureAtlas.textureNamed("Donut")
        menuButton.name = "DonutRestart"
        menuButton.position = CGPoint(x: centerOfHud.x, y: centerOfHud.y - 200 )
        menuButton.size = CGSize(width: 100, height: 100)
        menuButton.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(-5.0, duration: 20)))
        
        
        // Score Label
        labelScore.position = CGPoint(x: ((screenSize.width / 2) - 80), y: ((screenSize.height / 2) + 200))
        labelScore.fontName = font
        labelScore.fontSize = 25.0
        labelScore.userInteractionEnabled = false
        labelScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        labelScore.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        
        // Best Label
        labelBest.position = CGPoint(x: ((screenSize.width / 2) + 80), y: ((screenSize.height / 2) + 200))
        labelBest.fontName = font
        labelBest.fontSize = 25.0
        labelBest.userInteractionEnabled = false
        labelBest.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        labelBest.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        
        // Count Best
        coinCountBest.position = CGPoint(x: ((screenSize.width / 2) + 80), y: ((screenSize.height / 2) + 150))
        coinCountBest.fontName = font
        coinCountBest.fontSize = 40.0
        coinCountBest.userInteractionEnabled = false
        coinCountBest.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        coinCountBest.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        coinCountBest.fontColor = UIColor(red:0.95, green:0.36, blue:0.26, alpha:1.0)
        
        
        // Level Label 
        levelLabel.position = CGPoint(x: centerOfHud.x, y: centerOfHud.y - 250 )
        levelLabel.fontName = font
        levelLabel.fontSize = 40.0
        levelLabel.zPosition = 40
        levelLabel.userInteractionEnabled = false
        levelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        levelLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        levelLabel.fontColor = UIColor(red:0.95, green:0.36, blue:0.26, alpha:1.0)
        self.addChild(self.levelLabel)
        
        
        // Create heart nodes for the life meter
        for index in 0 ..< maxLifeCount {
            let newHeartNode = SKSpriteNode(texture:textureAtlas.textureNamed("Apple"))
            newHeartNode.size = CGSize(width: 25, height: 25)
            let xPos = CGFloat(index * 40 + 20)
            let yPos = screenSize.height - 30
            newHeartNode.position = CGPoint(x: xPos, y: yPos)
            
            heartNodes.append(newHeartNode)
            self.addChild(newHeartNode)
        }
        
        
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
    
    
    func showButtons(screenSize: CGSize) {
        
        // TODO make func for alpha add child and fade animation
        ralphFace.alpha = 0
        menuButton.alpha = 0
        labelScore.alpha = 0
        labelBest.alpha = 0
        coinCountBest.alpha = 0
        
        self.addChild(ralphFace)
        self.addChild(menuButton)
        self.addChild(labelScore)
        self.addChild(labelBest)
        self.addChild(coinCountBest)
        
        ralphFace.runAction(fadeInAnimation)
        menuButton.runAction(fadeInAnimation)
        labelScore.runAction(fadeInAnimation)
        labelBest.runAction(fadeInAnimation)
        coinCountBest.runAction(fadeInAnimation)
        
        coinCountText.position = CGPoint(x: ((screenSize.width / 2) - 80), y: ((screenSize.height / 2) + 150))
        coinCountText.fontColor = UIColor(red:0.00, green:0.75, blue:0.69, alpha:1.0)
        
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
        menuButton.runAction(fadeInAnimation)
        coinCountBest.runAction(fadeInAnimation)
        labelBest.runAction(fadeInAnimation)
        ralphFace.runAction(fadeInAnimation)
        labelScore.runAction(fadeInAnimation)
        coinCountText.runAction(fadeInAnimation)
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
            labelBest.position = CGPoint(x: (screenSize.width / 2), y: ((screenSize.height / 2) + 200))
            coinCountBest.position = CGPoint(x: (screenSize.width / 2), y: ((screenSize.height / 2) + 150))
            coinCountText.hidden = true
            labelScore.hidden = true
        }
        
    }
    
    
    // LifeCount
    
    func getCurrentLifeCount() -> Int {
        
        return PlistManager.sharedInstance.getValueForKey(pListLifeCount) as! Int
        
    }
    
    func resetLifeCount() {
        
        PlistManager.sharedInstance.saveValue(3, forKey: pListLifeCount)
    }
    
    func updateLifeScore(newLifeCount: Int) {
        
        PlistManager.sharedInstance.saveValue(newLifeCount, forKey: pListLifeCount)
    
    }
    
    func setHealthDisplay(newHealth: Int) {
        
        let fadeAction = SKAction.fadeAlphaTo(0.2, duration: 0)
        
        for index in 0 ..< 3 {
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














