
//
//  Premium.swift
//  Ralph
//
//  Created by Alexander Hipp on 24/11/16.
//  Copyright © 2016 LonelyGoldfish. All rights reserved.
//

import SpriteKit

class Premium {
    
    var status = false
    let premiumLabelPList = "premium"
    
    func checkIfUserIsPremium() -> Bool {
        
        return PlistManager.sharedInstance.getValueForKey(premiumLabelPList) as! Bool
        
    }
    
    func getPremium() {
        
        PlistManager.sharedInstance.saveValue(true, forKey: premiumLabelPList)
        
    }
    
    func stopPremium() {
        
        PlistManager.sharedInstance.saveValue(false, forKey: premiumLabelPList)
        
    }
    
    

}
