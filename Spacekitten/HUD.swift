//
//  HUD.swift
//  Spacekitten
//
//  Created by Alexander Hipp on 04/07/16.
//  Copyright © 2016 LonelyGoldfish. All rights reserved.
//

import SpriteKit

class HUD: SKNode {
    
    let coinCountText = SKLabelNode(text: "0")
    let ralphFace = SKSpriteNode()
    let menuButton = SKSpriteNode()
    
    let labelScore = SKLabelNode(text: "Score")
    let labelBest = SKLabelNode(text: "Best")
    let coinCountBest = SKLabelNode(text: "167")
    
    let levelLabel = SKLabelNode(text: "Level 0")
    
    let textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "sprites.atlas")
    
    let font = "CooperHewitt-Heavy"
    let fadeInAnimation = SKAction.fadeAlphaTo(1, duration: 0.9)
    let fadeOutAnimation = SKAction.fadeAlphaTo(0, duration: 0.9)
    
    
    func createHudNodes(screenSize: CGSize) {
        
        
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
        
        // Ralph Face
        ralphFace.texture = textureAtlas.textureNamed("Ralph-face")
        ralphFace.position = centerOfHud
        ralphFace.size = CGSize(width: 145, height: 145)
        ralphFace.zPosition = 12
        
        
        // Donut to restart the game
        menuButton.texture = textureAtlas.textureNamed("Donut")
        menuButton.name = "DonutRestart"
        menuButton.position = CGPoint(x: centerOfHud.x, y: centerOfHud.y - 200 )
        menuButton.size = CGSize(width: 60, height: 60)
        
        
        // Score Label
        labelScore.position = CGPoint(x: ((screenSize.width / 2) - 80), y: ((screenSize.height / 2) + 200))
        labelScore.fontName = font
        labelScore.fontSize = 25.0
        labelScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        labelScore.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        
        // Best Label
        labelBest.position = CGPoint(x: ((screenSize.width / 2) + 80), y: ((screenSize.height / 2) + 200))
        labelBest.fontName = font
        labelBest.fontSize = 25.0
        labelBest.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        labelBest.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        
        // Count Best
        coinCountBest.position = CGPoint(x: ((screenSize.width / 2) + 80), y: ((screenSize.height / 2) + 150))
        coinCountBest.fontName = font
        coinCountBest.fontSize = 40.0
        coinCountBest.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        coinCountBest.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        coinCountBest.fontColor = UIColor(red:0.95, green:0.36, blue:0.26, alpha:1.0)
        
        
        // Level Label 
        levelLabel.position = CGPoint(x: centerOfHud.x, y: centerOfHud.y - 250 )
        levelLabel.fontName = font
        levelLabel.fontSize = 40.0
        levelLabel.zPosition = 40
        levelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        levelLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        levelLabel.fontColor = UIColor(red:0.95, green:0.36, blue:0.26, alpha:1.0)
        self.addChild(self.levelLabel)
        
        
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
        menuButton.size = CGSize(width: 74, height: 74)
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
    
    
    let colorLevelLabel: [Int: UIColor] = [
        1: UIColor(red: 0, green: 0.7451, blue: 0.6863, alpha: 1.0), /* red #00beaf */
        2: UIColor(red: 0.9294, green: 0.8784, blue: 0.0588, alpha: 1.0), /* yellow #ede00f */
        3: UIColor(red: 0.2902, green: 0.5412, blue: 0.7843, alpha: 1.0), /* blue #4a8ac8 */
        4: UIColor(red: 0, green: 0.7451, blue: 0.6863, alpha: 1.0), /* green #00beaf */
        5: UIColor(red: 0.949, green: 0.3608, blue: 0.2627, alpha: 1.0) /* orange #f25c43 */
    ]
    
    
}














