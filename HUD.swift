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
    
    func createHudNodes(screenSize: CGSize) {
        let coinYPos = screenSize.height - 23
        coinCountText.fontName = "AvenirNext-HeavyItalic"
        coinCountText.position = CGPoint(x: 10, y: coinYPos)
        coinCountText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        coinCountText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        self.addChild(coinCountText)
    }
    
    func setCoinCounDisplay(newCoinCount: Int) {
        let formatter = NSNumberFormatter()
        formatter.minimumIntegerDigits = 6
        if let coinStr = formatter.stringFromNumber(newCoinCount) {
            coinCountText.text = coinStr
        }
    }
    
}
