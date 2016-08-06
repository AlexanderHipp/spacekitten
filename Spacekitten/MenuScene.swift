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
    let ralphHead = SKSpriteNode()
    let ralphFace = SKSpriteNode()
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

        
        // Ralph Head
        ralphHead.texture = textureAtlas.textureNamed("Ralph-head")
        ralphHead.position = CGPoint(x: 0, y: 0)
        ralphHead.size = CGSize(width: 145, height: 145)
        ralphHead.zPosition = 12
        self.addChild(ralphHead)
        
        // Ralph Face
        ralphFace.texture = textureAtlas.textureNamed("Ralph-face")
        ralphFace.position = CGPoint(x: 0, y: 0)
        ralphFace.size = CGSize(width: 145, height: 145)
        ralphFace.zPosition = 13
        self.addChild(ralphFace)
        
        
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
            
            let fadeAnimation = SKAction.fadeAlphaTo(0, duration: 0.9)
            
            if nodeTouched.name == "Donut" {
                
                runAction(
                    SKAction.sequence([
                        SKAction.runBlock({
                            self.donut.texture = SKTexture(imageNamed: "Donut-squished")
                            self.donut.size = CGSize(width: 74, height: 74)
                        }),
                        SKAction.runBlock({
                            self.donut.runAction(fadeAnimation)
                            self.logo.runAction(fadeAnimation)
                        }),
                        SKAction.runBlock({
                            self.view?.presentScene(GameScene(size: self.size), transition: .crossFadeWithDuration(0.9))
                        })
                    ])
                )
            }
        }
    }
}

















