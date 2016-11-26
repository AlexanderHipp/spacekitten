//
//  HUD.swift
//  Spacekitten
//
//  Created by Alexander Hipp on 04/07/16.
//  Copyright © 2016 LonelyGoldfish. All rights reserved.
//

import SpriteKit

class HUD: SKNode {
    
    let life = Life()
    let d = DeviceSize()
    let p = Premium()
    let t = Timer()
    
    
    let coinCountText = SKLabelNode(text: "0")
    let labelScore = SKLabelNode(text: "Score")
    var labelBest = SKLabelNode(text: "Best")
    var coinCountBest = SKLabelNode(text: "0")
    
    let labelGameOver = SKLabelNode(text: "Game Over")
    var waitingTime = SKLabelNode(text: "Wait for 6 mins")
    
    let buyFullVersionButton = SKSpriteNode()
    let closeFunnelButton = SKSpriteNode()
    let logo = SKSpriteNode()
    
    let emitter = SKEmitterNode(fileNamed: "NewHighscore")
    
    let levelLabel = SKLabelNode(text: "Level 0")
    
    let premiumLabel = SKLabelNode(text: "BASIC")
    let backgroundFunnel = SKSpriteNode()
    let menuButton = SKSpriteNode()
    let upsellButton = SKLabelNode(text: "Buy Fullversion")
    
    let textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "sprites.atlas")
    
    let font = "CooperHewitt-Heavy"
    let fadeInAnimation = SKAction.fadeAlphaTo(1, duration: 0.2)
    let fadeOutAnimation = SKAction.fadeAlphaTo(0, duration: 0.1)
    
    let highScore = "highScore"
    
    // Timer
    let timestampLifeTimer = "timestampLifeTimer"
    let lifeTimerRunning = "lifeTimerRunning"
    let formatter = NSDateFormatter()
    let userCalendar = NSCalendar.currentCalendar()
    let requestedComponent: NSCalendarUnit = [
        NSCalendarUnit.Minute,
        NSCalendarUnit.Second
    ]    
    var stringForTimer = ""
    var timer = NSTimer()
    var timerFinished = Bool()

    
    // An array to keep track of the hearts
    var heartNodes: [SKSpriteNode] = []
    
    
    func createHudNodes(screenSize: CGSize) {
        
        d.initDeviceSizes(screenSize)
        
        // Game Stats
        coinCountText.fontName = font
        coinCountText.position = CGPoint(x: d.middleX, y: d.height - 50)
        coinCountText.fontSize = 40.0
        coinCountText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        coinCountText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        coinCountText.alpha = 0
        
        
        // Before the game
        
        // Logo
        logo.texture = textureAtlas.textureNamed("DontFeedRalph")
        logo.position = CGPoint(x: d.middleX, y: d.middleY + 200)
        logo.size = CGSize(width: 190, height: 90)
        logo.alpha = 0
        
        // Button to start the game
        menuButton.texture = textureAtlas.textureNamed("Donut")
        menuButton.position = CGPoint(x: d.middleX, y: d.middleY - 200 )
        menuButton.size = CGSize(width: 100, height: 100)
        menuButton.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(-5.0, duration: 20)))
        menuButton.alpha = 0
        
        
        // After Player dies
        
        // Score Label
        labelScore.position = CGPoint(x: (d.middleX - 80), y: (d.middleY + 200))
        labelScore.fontName = font
        labelScore.fontSize = 25.0
        labelScore.userInteractionEnabled = false
        labelScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        labelScore.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        labelScore.alpha = 0
        
        // Best Label
        labelBest.fontName = font
        labelBest.fontSize = 25.0
        labelBest.userInteractionEnabled = false
        labelBest.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        labelBest.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        labelBest.alpha = 0
        
        // Count Best
        coinCountBest.fontName = font
        coinCountBest.fontSize = 40.0
        coinCountBest.userInteractionEnabled = false
        coinCountBest.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        coinCountBest.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        coinCountBest.fontColor = UIColor(red:0.95, green:0.36, blue:0.26, alpha:1.0)
        coinCountBest.alpha = 0
        
        positionLabelBestRight()
        
        // Level Label 
        levelLabel.position = CGPoint(x: d.middleX, y: d.middleY - 250 )
        levelLabel.fontName = font
        levelLabel.fontSize = 40.0
        levelLabel.zPosition = 40
        levelLabel.userInteractionEnabled = false
        levelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        levelLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        levelLabel.fontColor = UIColor(red:0.95, green:0.36, blue:0.26, alpha:1.0)
        levelLabel.alpha = 0
        
        
        // Nodes for Funnel
        
        // Game Over Label
        labelGameOver.position = CGPoint(x: d.middleX, y: (d.middleY + 200))
        labelGameOver.fontName = font
        labelGameOver.fontSize = 35.0
        labelGameOver.zPosition = 41
        labelGameOver.fontColor = UIColor(red:0.95, green:0.36, blue:0.26, alpha:1.0)
        labelGameOver.userInteractionEnabled = false
        labelGameOver.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        labelGameOver.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        labelGameOver.alpha = 0
        
        
        // Close Funnel Button
        closeFunnelButton.texture = textureAtlas.textureNamed("Cookie")
        closeFunnelButton.position = CGPoint(x: 40, y: d.height - 40 )
        closeFunnelButton.size = CGSize(width: 30, height: 30)        
        closeFunnelButton.alpha = 0
        closeFunnelButton.zPosition = 41
        closeFunnelButton.name = "BackFromFunnelToMenu"
        
        
        // Waiting Time
        waitingTime.position = CGPoint(x: d.middleX, y: (d.middleY + 150))
        waitingTime.fontName = font
        waitingTime.fontSize = 25.0
        waitingTime.zPosition = 41
        waitingTime.userInteractionEnabled = false
        waitingTime.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        waitingTime.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        waitingTime.fontColor = UIColor(red:0.95, green:0.36, blue:0.26, alpha:1.0)
        waitingTime.alpha = 0
        
        
        // Upsell Button
        upsellButton.position = CGPoint(x: d.middleX, y: d.middleY - 200 )
        upsellButton.fontName = font
        upsellButton.fontSize = 40.0
        upsellButton.zPosition = 41
        upsellButton.userInteractionEnabled = false
        upsellButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        upsellButton.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        upsellButton.fontColor = UIColor(red:0.95, green:0.36, blue:0.26, alpha:1.0)
        upsellButton.name = "UpsellConfirmation"
        upsellButton.alpha = 0
        
        // Premium label
        premiumLabel.position = CGPoint(x: d.width - 40, y: d.height - 40 )
        premiumLabel.fontName = font
        premiumLabel.fontSize = 10.0
        premiumLabel.zPosition = 41
        premiumLabel.userInteractionEnabled = false
        premiumLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        premiumLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        premiumLabel.fontColor = UIColor(red:0.95, green:0.36, blue:0.26, alpha:1.0)
        premiumLabel.alpha = 1
        
        if p.checkIfUserIsPremium() == true {
            premiumLabel.text = "PREMIUM"
        } else {
            premiumLabel.text = "BASIC"
        }
        
        
        // Background for the funnel
        backgroundFunnel.name = "bar"
        backgroundFunnel.size = CGSizeMake(CGFloat(d.width), CGFloat(d.height))
        backgroundFunnel.color = SKColor.whiteColor()
        backgroundFunnel.position = CGPoint(x: d.middleX, y: d.middleY)
        backgroundFunnel.zPosition = 40
        backgroundFunnel.alpha = 0
        
        
        
        // Apply all nodes to HUD
        self.addChild(levelLabel)
        self.addChild(labelScore)
        self.addChild(labelBest)
        self.addChild(labelGameOver)
        
        self.addChild(coinCountText)
        self.addChild(coinCountBest)
        self.addChild(waitingTime)
        
        self.addChild(menuButton)
        self.addChild(upsellButton)
        self.addChild(logo)
        
        self.addChild(premiumLabel)
        self.addChild(closeFunnelButton)
        
        self.addChild(backgroundFunnel)
        
        createHeartNodes()
        
    }
    
    func createHeartNodes() {
        // Create heart nodes for the life meter
        for index in 0 ..< life.maxLifeCount {
            let newHeartNode = SKSpriteNode(texture:textureAtlas.textureNamed("Apple"))
            newHeartNode.size = CGSize(width: 25, height: 25)
            let xPos = Int(index * 40 + 20)
            let yPos = d.height - 30
            newHeartNode.position = CGPoint(x: xPos, y: yPos)
            newHeartNode.alpha = 0
            
            heartNodes.append(newHeartNode)
            self.addChild(newHeartNode)
        }
    }
    
    func setCoinCounDisplay(newCoinCount: Int) {
        
        let formatter = NSNumberFormatter()
        formatter.minimumIntegerDigits = 1
        if let coinStr = formatter.stringFromNumber(newCoinCount) {
            coinCountText.text = coinStr
        }
    }
    
    func squishHUDDonut() {        
        menuButton.texture = SKTexture(imageNamed: "Donut-squished")
    }
    
    func unSquishHUDDonut() {
        menuButton.texture = SKTexture(imageNamed: "Donut")
    }
    
   
    
    
    // HUD setups
    
    func menuButtonShow() {
        displayButtonAccordingToGameover()
        menuButton.runAction(fadeInAnimation)
    }
    
    func menuButtonHide() {
        menuButton.runAction(fadeOutAnimation)
    }
    
    func logoShow() {
        logo.runAction(fadeInAnimation)
    }
    
    func logoHide() {
        logo.runAction(fadeOutAnimation)
    }
    
    
    func startMenuHide() {
        logo.runAction(fadeOutAnimation)
        menuButtonHide()
    }
    
    func labelMenuScoreShow() {
        coinCountText.position = CGPoint(x: (d.middleX - 80), y: (d.middleY + 150))
        coinCountText.fontColor = UIColor(red:0.00, green:0.75, blue:0.69, alpha:1.0)
        labelScore.runAction(fadeInAnimation)
        coinCountText.runAction(fadeInAnimation)
    }
    
    func labelMenuScoreHide() {
        labelScore.runAction(fadeOutAnimation)
        coinCountText.runAction(fadeOutAnimation)
    }
    
    func menuItemsShow(newHighscore: Bool) {
        
        setHealthDisplay()
        menuButtonShow()
        
        if (newHighscore == true) {
            labelBest.text = "New Highscore"
            positionLabelBestCentered()
            // letItRain()
        } else {
            labelBest.text = "Best"
            labelMenuScoreShow()
            positionLabelBestRight()
        }
        
        labelBest.runAction(fadeInAnimation)
        coinCountBest.runAction(fadeInAnimation)
    }
    
    func menuItemsHide() {
        menuButton.runAction(fadeOutAnimation)
        labelScore.runAction(fadeOutAnimation)
        labelBest.runAction(fadeOutAnimation)
        coinCountBest.runAction(fadeOutAnimation)
        coinCountText.runAction(fadeOutAnimation)
        hideHeartItems()
    }
    
    func menuItemsAfterPurchaseShow() {
        menuButtonShow()
        labelBest.runAction(fadeInAnimation)
        coinCountBest.runAction(fadeInAnimation)
        positionLabelBestCentered()
        coinCountText.fontColor = UIColor(red:0.00, green:0.75, blue:0.69, alpha:1.0)
    }
    
    func menuItemsAfterPurchaseHide() {
        menuButtonHide()
        labelBest.runAction(fadeOutAnimation)
        coinCountBest.runAction(fadeOutAnimation)
    }
    
    func gameItemsShow() {
        setHealthDisplay()
        coinCountText.position = CGPoint(x: d.middleX, y: (d.height - 50))
        coinCountText.fontColor = UIColor.whiteColor()
        coinCountText.runAction(fadeInAnimation)
        labelScore.runAction(fadeOutAnimation)
    }
    
    func gameItemsHide() {
        coinCountText.runAction(fadeOutAnimation)
        hideHeartItems()
    }
    
    func upsellPageShow() {
        labelGameOver.runAction(fadeInAnimation)
        waitingTime.runAction(fadeInAnimation)
        upsellButton.runAction(fadeInAnimation)
        closeFunnelButton.runAction(fadeInAnimation)
        backgroundFunnel.runAction(fadeInAnimation)
    }
    
    func upsellPageHide() {
        labelGameOver.runAction(fadeOutAnimation)
        waitingTime.runAction(fadeOutAnimation)
        upsellButton.runAction(fadeOutAnimation)
        closeFunnelButton.runAction(fadeOutAnimation)
        backgroundFunnel.runAction(fadeOutAnimation)
    }
    
    // END Hud setups
    
    
    func hideHeartItems() {
        for index in 0 ..< life.maxLifeCount {
            heartNodes[index].runAction(fadeOutAnimation)
        }
    }
    
    func displayButtonAccordingToGameover() {
        
        if (p.checkIfUserIsPremium() == false) && (life.checkLifeCountForGameover() == true) && (t.checkIfTimerIsRunning() == true) {
            print(t.checkIfTimerIsRunning())
            menuButton.name = "GoToUpsell"
        } else {
            menuButton.name = "StartGame"
        }
        print("Button:", menuButton.name)
    }
    
    func letItRain() {
        
        emitter!.hidden = false
        
        // Place the emitter at the rear of the ship.
        emitter!.position = CGPoint(x: d.middleX, y: d.height + 60)
        emitter!.particlePositionRange = CGVector(dx: d.width, dy: 20)
        emitter!.name = "NewHighscore"
        
        // Send the particles to the scene.
        emitter!.targetNode = scene;
        self.addChild(emitter!)
    }
    
    func showLevel(currentLevel: Int) {
        levelLabel.text = "Level \(currentLevel)"
        levelLabel.alpha = 0
        levelLabel.fontColor = colorLevelLabel[currentLevel]
        
        runAction(
            SKAction.sequence([
                SKAction.runBlock({
                    self.levelLabel.runAction(self.fadeInAnimation)
                }),
                SKAction.waitForDuration(1.0),
                SKAction.runBlock({
                    self.levelLabel.runAction(self.fadeOutAnimation)
                })
            ])
        )
    }
    
    
    // Connection to Plist for Highscore
    
    func updateHighScore() {
        
        if let highScoreValue = PlistManager.sharedInstance.getValueForKey(highScore) {
            coinCountBest.text = "\(highScoreValue)"
        } else {
            coinCountBest.text = "0"
        }
        
    }
    
    func checkIfNewHighScore(newHighScore: Int) -> Bool {
        
        let oldHighScoreValue: Int = PlistManager.sharedInstance.getValueForKey(highScore) as! Int
        
        if newHighScore > oldHighScoreValue {
            PlistManager.sharedInstance.saveValue(newHighScore, forKey: highScore)
            updateHighScore()
            return true
        } else {
            return false
        }
    }
    
    // Label position
    
    func positionLabelBestCentered() {
        labelBest.position = CGPoint(x: d.middleX, y: (d.middleY + 200))
        coinCountBest.position = CGPoint(x: d.middleX, y: (d.middleY + 150))
        coinCountText.runAction(fadeOutAnimation)
        labelScore.runAction(fadeOutAnimation)
    }
    
    func positionLabelBestRight() {
        labelBest.position = CGPoint(x: (d.middleX + 80), y: (d.middleY + 200))
        coinCountBest.position = CGPoint(x: (d.middleX + 80), y: (d.middleY + 150))
    }
    
    
    
    func setHealthDisplay() {
        
        createHeartNodes()
        
        if (p.checkIfUserIsPremium() == false) {
            
            let fadeAction = SKAction.fadeAlphaTo(0.2, duration: 0)
            
            for index in 0 ..< life.maxLifeCount {
                
                if index < life.getCurrentLifeCount() {
                    heartNodes[index].alpha = 1
                } else {
                    heartNodes[index].runAction(fadeAction)
                }
            }
        } else {
            hideHeartItems()
            print("User is premium therefore don't show the health display")
        }
    }
    
   
    
    
    // Colors for Level Labels
    
    let colorLevelLabel: [Int: UIColor] = [
        1: UIColor(red: 0, green: 0.7451, blue: 0.6863, alpha: 1.0), /* red #00beaf */
        2: UIColor(red: 0.9294, green: 0.8784, blue: 0.0588, alpha: 1.0), /* yellow #ede00f */
        3: UIColor(red: 0.2902, green: 0.5412, blue: 0.7843, alpha: 1.0), /* blue #4a8ac8 */
        4: UIColor(red: 0, green: 0.7451, blue: 0.6863, alpha: 1.0), /* green #00beaf */
        5: UIColor(red: 0.949, green: 0.3608, blue: 0.2627, alpha: 1.0) /* orange #f25c43 */
    ]
    
    
    // TIMER
    
    @objc func printTime() {
        
        let startTime = NSDate()
        let endTime = getEndTimePList()

        let timeDifference = userCalendar.components(requestedComponent, fromDate: startTime, toDate: endTime, options: [])
        waitingTime.text = "Please wait \(timeDifference.minute):\(String(format: "%02d", timeDifference.second)) mins or"
        
        timerFinished = checkIfTimerFinished(timeDifference)
        
        if timerFinished == true {
            
            endTimer()
            // Reset the life count to max
            life.resetLifeCount()
            
            // Update Menu
            upsellPageHide()
            menuItemsShow(false)
            
        }
        
        print("Timer", stringForTimer)
        
    }
    
    
    func getEndTimePList() -> NSDate {
        
        return PlistManager.sharedInstance.getValueForKey(timestampLifeTimer) as! NSDate
        
    }
    
    func setEndTimePList() {
        
        let endTime = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateByAddingUnit(.Minute, value: 6, toDate: endTime, options: [])
        
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














