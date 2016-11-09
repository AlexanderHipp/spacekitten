//
//  Level.swift
//  Spacekitten
//
//  Created by Alexander Hipp on 10/08/16.
//  Copyright © 2016 LonelyGoldfish. All rights reserved.
//

import SpriteKit

class Level {
    
    var levelValue = 0
    
    func checkLevel(destroyedEnemies: Int, currentLevel: Int) -> Int {
        
        switch destroyedEnemies {
        case 0 ... 6:
            return 1
            
        case 7 ... 14:
            return 2
            
        case 15 ... 31:
            return 3
            
        case 32 ... 66:
            return 4
            
        case 67 ... 114:
            return 5
            
        case 115 ... 183:
            return 6
            
        case 184 ... 287:
            return 7
            
        case 288 ... 381:
            return 8
            
        case 382 ... 599:
            return 9
            
        case 600 ... 9999999999999:
            return 10
            
        default:
            return currentLevel
        }
    }
    
    
}
