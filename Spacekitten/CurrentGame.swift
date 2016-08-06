//
//  CurrentGame.swift
//  Spacekitten
//
//  Created by Alexander Hipp on 30/07/16.
//  Copyright © 2016 LonelyGoldfish. All rights reserved.
//

import SpriteKit

class CurrentGame {
    
    var enemiesDestroyed = 0
    var currentLevel = 1
    
    
    func levelUp() {
        self.currentLevel += 1
    }
    
}
