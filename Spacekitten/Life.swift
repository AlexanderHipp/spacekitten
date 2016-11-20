//
//  Life.swift
//  Ralph
//
//  Created by Alexander Hipp on 20/11/16.
//  Copyright © 2016 LonelyGoldfish. All rights reserved.
//

import SpriteKit

class Life: SKNode {
    
    let pListLifeCount = "pListLifeCount"
    let maxLifeCount = 3
        
    func getCurrentLifeCount() -> Int {
        
        return PlistManager.sharedInstance.getValueForKey(pListLifeCount) as! Int
        
    }
    
    func resetLifeCount() {
        
        PlistManager.sharedInstance.saveValue(maxLifeCount, forKey: pListLifeCount)
    }
    
    func updateLifeScore(newLifeCount: Int) {
        
        PlistManager.sharedInstance.saveValue(newLifeCount, forKey: pListLifeCount)
        
    }
    
}
