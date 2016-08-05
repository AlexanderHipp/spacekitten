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
    let ralphHead = SKSpriteNode()
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
        
        let centerOfHud = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
        
        
        // Ralph Head
        ralphHead.texture = textureAtlas.textureNamed("Ralph-head")
        ralphHead.name = "restartButton"
        ralphHead.position = centerOfHud
        ralphHead.size = CGSize(width: 145, height: 145)
        ralphHead.zPosition = 12
        
        // Ralph Face
        ralphFace.texture = textureAtlas.textureNamed("Ralph-face")
        ralphFace.position = centerOfHud
        ralphFace.size = CGSize(width: 145, height: 145)
        ralphFace.zPosition = 12
        
        
        // Button
        menuButton.texture = textureAtlas.textureNamed("blue")
        menuButton.name = "returnToMenu"
        menuButton.position = CGPoint(x: centerOfHud.x - 140, y: centerOfHud.y )
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
        
        ralphHead.alpha = 0
        ralphFace.alpha = 0
        menuButton.alpha = 0
        self.addChild(ralphHead)
        self.addChild(ralphFace)
        self.addChild(menuButton)
        
        let fadeAnimation = SKAction.fadeAlphaTo(1, duration: 0.4)
        ralphHead.runAction(fadeAnimation)
        ralphFace.runAction(fadeAnimation)
        menuButton.runAction(fadeAnimation)
    }
    
}
