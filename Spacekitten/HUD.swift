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
    let ralph = SKSpriteNode()
    let menuButton = SKSpriteNode()
    
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
        
        // Button
        ralph.texture = textureAtlas.textureNamed("Ralph")
        menuButton.texture = textureAtlas.textureNamed("blue")
        
        ralph.name = "restartButton"
        menuButton.name = "returnToMenu"
        
        let centerOfHud = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
        ralph.position = centerOfHud
        menuButton.position = CGPoint(x: centerOfHud.x - 140, y: centerOfHud.y )
        
        ralph.size = CGSize(width: 145, height: 145)
        menuButton.size = CGSize(width: 35, height: 35)
    }
    
    
    func setCoinCounDisplay(newCoinCount: Int) {
        let formatter = NSNumberFormatter()
        formatter.minimumIntegerDigits = 1
        if let coinStr = formatter.stringFromNumber(newCoinCount) {
            coinCountText.text = coinStr
        }
    }
    
    func showButtons() {
        
        ralph.alpha = 0
        menuButton.alpha = 0
        self.addChild(ralph)
        self.addChild(menuButton)
        
        let fadeAnimation = SKAction.fadeAlphaTo(1, duration: 0.4)
        ralph.runAction(fadeAnimation)
        menuButton.runAction(fadeAnimation)
    }
    
}
