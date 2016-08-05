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
    let logo = SKSpriteNode()
    let ralph = SKSpriteNode()
    let donut = SKSpriteNode()
    
    
    override func didMoveToView(view: SKView) {
        
        // Position nodes from the center of the screen
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Background color and image
        backgroundColor = SKColor.blackColor()
        
        // Logo
        logo.texture = textureAtlas.textureNamed("DontFeedRalph")
        logo.position = CGPoint(x: 0, y: 200)
        logo.size = CGSize(width: 190, height: 90)
        logo.zPosition = 14
        self.addChild(logo)

        
        // Ralph
        ralph.texture = textureAtlas.textureNamed("Ralph")
        ralph.position = CGPoint(x: 0, y: 0)
        ralph.size = CGSize(width: 145, height: 145)
        ralph.zPosition = 14
        self.addChild(ralph)
        
        
        // Donut to start the game
        donut.texture = textureAtlas.textureNamed("Donut")
        donut.name = "Donut"
        donut.position = CGPoint(x: 0, y: -200)
        donut.size = CGSize(width: 60, height: 60)
        donut.zPosition = 14
        self.addChild(donut)
        
        
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        for touch in touches! {
            let location = touch.locationInNode(self)
            let nodeTouched = nodeAtPoint(location)
            
            
            
            if nodeTouched.name == "Donut" {
                self.view?.presentScene(GameScene(size: self.size))
            }
        }
    }
}

















