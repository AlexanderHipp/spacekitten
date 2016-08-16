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
        case 0 ... 4:
            return 1
        case 5 ... 7:
            return 2
        case 8 ... 10:
            return 3
        case 11 ... 15:
            return 4
        case 16 ... 18:
            return 5
        default:
            return currentLevel
        }
    }
    
    
}
