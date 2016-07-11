//
//  MenuScene.swift
//  Spacekitten
//
//  Created by Alexander Hipp on 06/07/16.
//  Copyright © 2016 LonelyGoldfish. All rights reserved.
//

import SpriteKit


class MenuScene: SKScene {
    
    let textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "sprites.atlas")
    let startButton = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        
        // Position nodes from the center of the screen
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Background color and image
        let backgroundImage = SKSpriteNode(imageNamed: "Background-menu")
        backgroundImage.size = CGSize(width: 750, height: 1075)
        self.addChild(backgroundImage)
        
        // Headline
        let logoText = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        logoText.text = "Spacekitten"
        logoText.position = CGPoint(x: 0, y: 100)
        logoText.fontSize = 30
        self.addChild(logoText)
        
        // Subline
        let logoTextBottom = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        logoTextBottom.text = "Rescue the circle"
        logoTextBottom.position = CGPoint(x: 0, y: 50)
        logoTextBottom.fontSize = 20
        
        // Start Game button
        startButton.self.color = UIColor.blackColor()
        startButton.size = CGSize(width: 300, height: 100)
        startButton.name = "StartBtn"
        startButton.position = CGPoint(x: 0, y: -20)
        self.addChild(startButton)
        
        // Text for the start button
        let startText = SKLabelNode(fontNamed: "AvenirNext-HeavyItalic")
        startText.text = "START GAME"
        startText.verticalAlignmentMode = .Center
        startText.position = CGPoint(x: 0, y: 2)
        startText.fontSize = 20
        startText.name = "StartBtn"
        startButton.addChild(startText)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        for touch in touches! {
            let location = touch.locationInNode(self)
            let nodeTouched = nodeAtPoint(location)
            
            
            
            if nodeTouched.name == "StartBtn" {
                self.view?.presentScene(GameScene(size: self.size))
            }
        }
    }
}

















