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
    let logoText = SKLabelNode()
    let startButton = SKSpriteNode()
    
    
    override func didMoveToView(view: SKView) {
        
        // Position nodes from the center of the screen
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Background color and image
        let backgroundImage = SKSpriteNode(imageNamed: "Background-menu")
        backgroundImage.size = CGSize(width: 750, height: 1075)
        self.addChild(backgroundImage)
        
        // Headline
        logoText.fontName = "AvenirNext-Heavy"
        logoText.text = "Spacekitten"
        logoText.position = CGPoint(x: 0, y: 100)
        logoText.zPosition = 14        
        logoText.fontSize = 30
        self.addChild(logoText)
        
        // Restart Button
        startButton.texture = textureAtlas.textureNamed("red")
        startButton.name = "StartBtn"
        startButton.position = CGPoint(x: 0, y: 0)
        startButton.size = CGSize(width: 60, height: 60)
        startButton.zPosition = 14
        self.addChild(startButton)
        
        
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

















