//
//  Timer.swift
//  Ralph
//
//  Created by Alexander Hipp on 26/11/16.
//  Copyright © 2016 LonelyGoldfish. All rights reserved.
//

import UIKit
import SpriteKit

class Timer {
    
    let life = Life()
    
    let timestampLifeTimer = "timestampLifeTimer"
    let lifeTimerRunning = "lifeTimerRunning"
    
    let formatter = NSDateFormatter()
    let userCalendar = NSCalendar.currentCalendar()
    let requestedComponent: NSCalendarUnit = [
        NSCalendarUnit.Month,
        NSCalendarUnit.Day,
        NSCalendarUnit.Hour,
        NSCalendarUnit.Minute,
        NSCalendarUnit.Second
    ]
    
    var stringForTimer = ""
    var timer = NSTimer()
    var timerFinished = Bool()
 
    
    @objc func printTime() {
        
        let startTime = NSDate()
        let endTime = getEndTimePList()
        
        let timeDifference = userCalendar.components(requestedComponent, fromDate: startTime, toDate: endTime, options: [])
        
        stringForTimer = "\(timeDifference.minute) minutes \(timeDifference.second) seconds"
        
        timerFinished = checkIfTimerFinished(timeDifference)
        
        if timerFinished == true {
            
            endTimer()            
            // Reset the life count to max
            life.resetLifeCount()
            
        }
        
        print("Timer", stringForTimer)
        print(timerFinished)        
        
    }
    
    
    func getEndTimePList() -> NSDate {
        
        return PlistManager.sharedInstance.getValueForKey(timestampLifeTimer) as! NSDate
        
    }
    
    func setEndTimePList() {
        
        let endTime = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateByAddingUnit(.Second, value: 10, toDate: endTime, options: [])
        
        PlistManager.sharedInstance.saveValue(date!, forKey: timestampLifeTimer)
        
    }
    
    func startTimer(){
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.printTime), userInfo: nil, repeats: true)
        
        timerFinished = false
        timer.fire()
        PlistManager.sharedInstance.saveValue(true, forKey: lifeTimerRunning)
        
    }
    
    func endTimer(){
        
        timerFinished = true
        timer.invalidate()
        PlistManager.sharedInstance.saveValue(false, forKey: lifeTimerRunning)        
        
    }
    
    func checkIfTimerFinished(difference: NSDateComponents) -> Bool {
        
        if (difference.minute == 0) && (difference.second == 0) {
            return true
        } else {
            return false
        }
    }
    
    func checkIfTimerIsRunning() -> Bool {
        
        // check if the timer is runnin in the plist and check if the timestamp in the plist is in the past
        let plistInfo = PlistManager.sharedInstance.getValueForKey(lifeTimerRunning) as! Bool
        let timestamp = PlistManager.sharedInstance.getValueForKey(timestampLifeTimer) as! NSDate
        
        if (plistInfo == false) || (timestamp.timeIntervalSinceNow.isSignMinus) {
            return false
        } else {
            return true
        }
        
    }
    
}

