//
//  DeviceSize.swift
//  Ralph
//
//  Created by Alexander Hipp on 21/11/16.
//  Copyright © 2016 LonelyGoldfish. All rights reserved.
//

import SpriteKit

class DeviceSize: SKNode {
    
    var width = 0
    var height = 0
    
    var middleX = 0
    var middleY = 0
    
    var center = CGPoint(x: 0, y: 0)
    
    func initDeviceSizes(screenSize: CGSize) {
        
        width = Int(screenSize.width)
        height = Int(screenSize.height)
        
        middleX = Int(screenSize.width / 2)
        middleY = Int(screenSize.height / 2)
        
        center = CGPoint(x: middleX, y: middleY)                
        
    }
}
