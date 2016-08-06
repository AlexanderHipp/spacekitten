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
    
    let textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "sprites.atlas")
    
    
    func createHudNodes(screenSize: CGSize) {
        
        
        // Game Stats
        let coinXPos = screenSize.width / 2
        let coinYPos = screenSize.height - 50
        coinCountText.fontName = "CooperHewitt-Heavy"
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
        menuButton.name = "restartButton"
        menuButton.position = CGPoint(x: centerOfHud.x, y: centerOfHud.y - 200 )
        menuButton.size = CGSize(width: 60, height: 60)
        
        
        // Score Label
        labelScore.position = CGPoint(x: ((screenSize.width / 2) - 80), y: ((screenSize.height / 2) + 200))
        labelScore.fontName = "CooperHewitt-Heavy"
        labelScore.fontSize = 25.0
        labelScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        labelScore.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        
        // Best Label
        labelBest.position = CGPoint(x: ((screenSize.width / 2) + 80), y: ((screenSize.height / 2) + 200))
        labelBest.fontName = "CooperHewitt-Heavy"
        labelBest.fontSize = 25.0
        labelBest.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        labelBest.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        
        // Count Best
        coinCountBest.position = CGPoint(x: ((screenSize.width / 2) + 80), y: ((screenSize.height / 2) + 150))
        coinCountBest.fontName = "CooperHewitt-Heavy"
        coinCountBest.fontSize = 40.0
        coinCountBest.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        coinCountBest.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        coinCountBest.fontColor = UIColor(red:0.95, green:0.36, blue:0.26, alpha:1.0)
        
        
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
    
    func fadeOutHUDelements() {
        let fadeAnimation = SKAction.fadeAlphaTo(0, duration: 0.9)
        menuButton.runAction(fadeAnimation)
        coinCountBest.runAction(fadeAnimation)
        labelBest.runAction(fadeAnimation)
        ralphFace.runAction(fadeAnimation)
        labelScore.runAction(fadeAnimation)
        coinCountText.runAction(fadeAnimation)
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
        
        let fadeAnimation = SKAction.fadeAlphaTo(1, duration: 0.9)
        ralphFace.runAction(fadeAnimation)
        menuButton.runAction(fadeAnimation)
        labelScore.runAction(fadeAnimation)
        labelBest.runAction(fadeAnimation)
        coinCountBest.runAction(fadeAnimation)
        
        coinCountText.position = CGPoint(x: ((screenSize.width / 2) - 80), y: ((screenSize.height / 2) + 150))
        coinCountText.fontColor = UIColor(red:0.00, green:0.75, blue:0.69, alpha:1.0)
        
    }
    
}
