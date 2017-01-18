//
//  Bubble.swift
//  Ralph
//
//  Created by Alexander Hipp on 17/10/16.
//  Copyright © 2016 LonelyGoldfish. All rights reserved.
//


import SpriteKit



class Bubble: SKNode {
    
    
    let calculationOfRandom = Calculation()
    let textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "sprites.atlas")    
    
    func spawnBubble(sizeScreen: CGSize, typeOfEnemy: String) -> SKSpriteNode {
        
        let bubble = SKSpriteNode(imageNamed:typeOfEnemy)
        
        bubble.size = CGSize(width: 10, height: 10)
        let bubbleRandomPosition = defineBubbleGoalPosition(sizeScreen, bubbleSize: bubble.size)
        
        bubble.position = CGPoint(x: sizeScreen.width/2, y: sizeScreen.height/2)
        bubble.zPosition = 50
        
        // Add the enemy to the scene
        bubble.runAction(SKAction.sequence([
            SKAction.group([
                SKAction.moveTo(bubbleRandomPosition, duration: 8),
                SKAction.fadeAlphaTo(0, duration: 1.0),
            ]),
            SKAction.runBlock({ 
                bubble.removeAllChildren()
                bubble.removeFromParent()
            })
        ]))
        
        return bubble

    }
    
    func defineBubbleGoalPosition(sizeScreen: CGSize, bubbleSize: CGSize) -> CGPoint {
        
        // Determine where to send the bubble along the Y axis, left or right
        let actualY = calculationOfRandom.random(min: bubbleSize.height/2, max: sizeScreen.height - bubbleSize.height/2)
        let leftSide = -bubbleSize.width/2
        let rightSide = sizeScreen.width + bubbleSize.width/2
        let actualSideLeftRight = [leftSide, rightSide]
        
        // left or right
        let positionLeftRight = CGPoint(x: actualSideLeftRight.sample(), y: actualY)
        
        // Determine where to spawn the enemy along the x axis, bottom or top
        let actualX = calculationOfRandom.random(min: bubbleSize.width/2, max: sizeScreen.width - bubbleSize.width/2)
        let bottomSide = -bubbleSize.height/2
        let topSide = sizeScreen.height + bubbleSize.height/2
        let actualSideBottomTop = [bottomSide, topSide]
        
        // bottom or top
        let positionBottomTop = CGPoint(x: actualX, y: actualSideBottomTop.sample())
        
        // Choose random side
        let leftRightBottomTop = [positionLeftRight, positionBottomTop]
        
        return leftRightBottomTop.sample()
        
    }
    
    
}

