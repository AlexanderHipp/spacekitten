//
//  HUD.swift
//  Spacekitten
//
//  Created by Alexander Hipp on 04/07/16.
//  Copyright © 2016 LonelyGoldfish. All rights reserved.
//

import SpriteKit

class HUD: SKNode {
    
    let coinCountText = SKLabelNode(text: "000000")
    let restartButton = SKSpriteNode()
    let menuButton = SKSpriteNode()
    
    let textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "sprites.atlas")
    
    
    func createHudNodes(screenSize: CGSize) {
        
        // Game Stats
        let coinYPos = screenSize.height - 23
        coinCountText.fontName = "AvenirNext-HeavyItalic"
        coinCountText.position = CGPoint(x: 10, y: coinYPos)
        coinCountText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        coinCountText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        self.addChild(coinCountText)
        
        // Button
        restartButton.texture = textureAtlas.textureNamed("red")        
        menuButton.texture = textureAtlas.textureNamed("blue")
        
        restartButton.name = "restartButton"
        menuButton.name = "returnToMenu"
        
        let centerOfHud = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
        restartButton.position = centerOfHud
        menuButton.position = CGPoint(x: centerOfHud.x - 140, y: centerOfHud.y )
        
        restartButton.size = CGSize(width: 60, height: 60)
        menuButton.size = CGSize(width: 35, height: 35)
    }
    
    
    func setCoinCounDisplay(newCoinCount: Int) {
        let formatter = NSNumberFormatter()
        formatter.minimumIntegerDigits = 6
        if let coinStr = formatter.stringFromNumber(newCoinCount) {
            coinCountText.text = coinStr
        }
    }
    
    func showButtons() {
        
        restartButton.alpha = 0
        menuButton.alpha = 0
        self.addChild(restartButton)
        self.addChild(menuButton)
        
        let fadeAnimation = SKAction.fadeAlphaTo(1, duration: 0.4)
        restartButton.runAction(fadeAnimation)
        menuButton.runAction(fadeAnimation)
    }
    
}
