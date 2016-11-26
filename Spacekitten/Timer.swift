//
//  Timer.swift
//  Ralph
//
//  Created by Alexander Hipp on 26/11/16.
//  Copyright © 2016 LonelyGoldfish. All rights reserved.
//

import UIKit
import SpriteKit

class Timer: UIViewController {
    
    let timestampLifeTimer = "timestampLifeTimer"
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(printTime), userInfo: nil, repeats: true)
        
        startTimer()
    }
    
    func printTime() {
        
//        formatter.dateFormat = "MM/dd/yy hh:mm:ss a"
        let startTime = NSDate()
        let endTime = getEndTimePList()
        
        let timeDifference = userCalendar.components(requestedComponent, fromDate: startTime, toDate: endTime, options: [])
        
        stringForTimer = "\(timeDifference.minute) minutes \(timeDifference.second) seconds"
        print("Timer", stringForTimer)
        
    }
    
    func getEndTimePList() -> NSDate {
        
        return PlistManager.sharedInstance.getValueForKey(timestampLifeTimer) as! NSDate
        
    }
    
    func setEndTimePList() {
        
        let endTime = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateByAddingUnit(.Minute, value: 5, toDate: endTime, options: [])
        
        PlistManager.sharedInstance.saveValue(date!, forKey: timestampLifeTimer)
        
    }
    
    func endTimer(){
        
        timer.invalidate()
        
    }
    
    func startTimer(){
        
        timer.fire()
        
    }

    
}

