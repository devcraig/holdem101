//
//  GameScene.swift
//  Hold'em 101
//
//  Created by Devin Craig on 3/9/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var playdeck: deck?
    var humanPlayer: Player?
    
    //  var tableCards: [Card]
    
    var pot: Int = 0
    var gamePos: Int = 1
    var potSize: SKLabelNode?
    
    //    var balance: Int = 100
    
    var card1: SKSpriteNode?
    var card2: SKSpriteNode?
    
    var resetBool = false
    var alertBool = false
    
    var check: CheckNode?
    var bet: BetNode?
    
    var balanceLabel: SKLabelNode?
    var cpu1Label: SKLabelNode?
    var cpu2Label: SKLabelNode?
    var cpu3Label: SKLabelNode?
    
    var handstren: TouchableSpriteNode?
    
   
    
    
    override func didMove(to view: SKView) {
        playdeck = deck(numplayers: 4, tut: true, buyIn: 100)
        humanPlayer = getPlayer()
        print("ffffff")
        
        let cardone = humanPlayer?.hand[0]
        let cardtwo = humanPlayer?.hand[1]
        let string1 = "card-" + CardToTypeString(card: cardone!) + "-" + CardToSuitString(card: cardone!)
        let string2 = "card-" + CardToTypeString(card: cardtwo!) + "-" + CardToSuitString(card: cardtwo!)
        
        card1 = SKSpriteNode(imageNamed: string1)
        
        if  (CardToSuitString(card: cardone!) == "hearts" || CardToSuitString(card: cardone!) == "diamonds"){
            card1?.color = UIColor.red
            card1?.colorBlendFactor = 0.5
        }
        else {
            card1?.color = UIColor.black
            card1?.colorBlendFactor = 0.5
        }
        card2 = SKSpriteNode(imageNamed: string2)
        
        if  (CardToSuitString(card: cardtwo!) == "hearts" || CardToSuitString(card: cardtwo!) == "diamonds"){
            card2?.color = UIColor.red
            card2?.colorBlendFactor = 0.5
        }
        else {
            card2?.color = UIColor.black
            card2?.colorBlendFactor = 0.5
        }
        
        card1?.position = CGPoint(x: -25, y: -75)
        card1?.size = CGSize(width: 65, height: 80)
        card2?.position = CGPoint(x: 25, y: -75)
        card2?.size = CGSize(width: 65, height: 80)
        
        potSize = SKLabelNode(fontNamed: "Arial")
        potSize?.text =  String(pot)
        potSize?.fontSize = 30
        potSize?.fontColor = SKColor.white
        potSize?.position = CGPoint(x: 10, y: 45)
        
     
        let cpu1 = SKSpriteNode(imageNamed: "CpuCards")
        let cpu2 = SKSpriteNode(imageNamed: "CpuCards")
        let cpu3 = SKSpriteNode(imageNamed: "CpuCards")
        
        cpu1.position = CGPoint(x: 230, y: 100)
        cpu1.size = CGSize(width: 80, height: 80)
        cpu1.zRotation = .pi / 8 * 6
        
        cpu2.position = CGPoint(x: 230, y: -40)
        cpu2.size = CGSize(width: 80, height: 80)
        cpu2.zRotation = .pi / 8
        
        cpu3.position = CGPoint(x: -230, y: -40)
        cpu3.size = CGSize(width: 80, height: 80)
        cpu3.zRotation = .pi / 8 * 13
        
        addChild(cpu1)
        addChild(cpu2)
        addChild(cpu3)
        
        addChild(potSize!)
        potSize?.name = "pot"
        addChild(card1!)
        card1?.name = "card1"
        addChild(card2!)
        card2?.name = "card2"
        
        animateNodes([card1!, card2!])
        
        let alert1 = SKLabelNode(fontNamed: "Arial")
        alert1.text =  "Each player is dealt two private cards, after which there is a betting round. Then three community cards are dealt face up (the Flop), followed by a second betting round. A fourth community card is dealt face up (the Turn), followed by a third betting round. A fifth community card is dealt face up (the River) and the the fourth and final betting round. At the Showdown, each player plays the best five-card hand they can make using any five cards from the two pocket cards and the five community cards (or Board Cards). \n\nShake to Fold"
        alert1.fontSize = 20
        alert1.fontColor = SKColor.white
        alert1.position = CGPoint(x: 0, y: -40)
        alert1.zPosition = 100
        alert1.lineBreakMode = NSLineBreakMode.byWordWrapping
        alert1.numberOfLines = 7
        alert1.preferredMaxLayoutWidth = CGFloat(700)
        
        let background1 = SKShapeNode(rect: CGRect(origin: CGPoint(x: -400, y: -190), size: CGSize(width: 800, height: 380)), cornerRadius: CGFloat(15))
        background1.zPosition = 99
        background1.name = "alert1"
        background1.fillColor = UIColor(red: 0, green: 100, blue: 0, alpha: 1)
        
        let alert2 = SKLabelNode(fontNamed: "Arial")
        alert2.text =  "Close"
        alert2.fontSize = 18
        alert2.fontColor = SKColor.white
        alert2.position = CGPoint(x: 0, y: -140)
        alert2.zPosition = 100
        let buttonCancel = TouchableSpriteNode(rect: CGRect(origin: CGPoint(x: -100, y: -170), size: CGSize(width: 200, height: 70)), cornerRadius: CGFloat(15))
        buttonCancel.fillColor = UIColor.red
        buttonCancel.zPosition = 99
        buttonCancel.addChild(alert2)
        //buttonCancel.position = CGPoint(x: 0, y: -100)
        buttonCancel.isUserInteractionEnabled = true
        buttonCancel.name = "close"
        
        balanceLabel = SKLabelNode(fontNamed: "Arial")
        balanceLabel?.text =  "$"+String((self.playdeck?.getPlayer().chips)!)
        balanceLabel?.fontSize = 35
        balanceLabel?.fontColor = SKColor.white
        balanceLabel?.position = CGPoint(x: 175, y: -175)
        
        addChild(balanceLabel!)
        balanceLabel?.name = "balance"
        //balanceLabel?.zPosition = 100
        
        cpu1Label = self.childNode(withName: "CPU1_money") as? SKLabelNode
        cpu2Label = self.childNode(withName: "CPU2_money") as? SKLabelNode
        cpu3Label = self.childNode(withName: "CPU3_money") as? SKLabelNode
        
        handstren = TouchableSpriteNode(rect: CGRect(origin: CGPoint(x: 240, y: -180), size: CGSize(width: 180, height: 60)), cornerRadius: CGFloat(15))
        handstren!.fillColor = UIColor.brown
        handstren!.zPosition = 4
        
        let alerts = SKLabelNode(fontNamed: "Arial")
        alerts.text =  "Hand Strengths"
        alerts.fontSize = 20
        alerts.fontColor = SKColor.white
        alerts.position = CGPoint(x: 330, y: -160)
        alerts.zPosition = 6
        
        handstren!.addChild(alerts)
        handstren!.isUserInteractionEnabled = true
        handstren!.selectedHandler = {
            print("hello")
            self.alertBool = true
            //show hand strengths
            let handStreren = SKSpriteNode(imageNamed: "handstrengthImage")
            handStreren.zPosition = 320
            handStreren.setScale(CGFloat(2))
            self.addChild(handStreren)
            handStreren.name = "handstrens"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
                if let child = self.childNode(withName: "handstrens") {
                    child.removeFromParent()
                    self.alertBool = false
                }
            }
            
        }
        
        self.addChild(handstren!)
        
        buttonCancel.selectedHandler = {
            if let child = self.childNode(withName: "alert1") as? SKShapeNode {
                child.removeFromParent()
            }
        }
        
        background1.addChild(buttonCancel)
        background1.addChild(alert1)
        animateLabel([background1])
        self.addChild(background1)
        
        check = self.childNode(withName: "check") as? CheckNode
        
        check!.selectedHandler = {
            if self.alertBool == false && !self.resetBool {
                if self.gamePos == 1 {
                    self.flop()
                    self.gamePos+=1
                    print("players left \(String(describing: self.playdeck?.getPlayersLeft()))")
                    if (self.playdeck?.getPlayersLeft())! <= 1 {
                        self.finishHand()
                    }
                    else {
                        self.playerStrength()
                    }
                }
                else if self.gamePos == 2 {
                    self.turn()
                    self.gamePos += 1
                    print("players left \(String(describing: self.playdeck?.getPlayersLeft()))")
                    if (self.playdeck?.getPlayersLeft())! <= 1 {
                        self.finishHand()
                    }
                    else {
                        self.playerStrength()
                    }
                    
                }
                else if self.gamePos == 3{
                    self.river()
                    self.gamePos += 1
                    print("players left \(String(describing: self.playdeck?.getPlayersLeft()))")
                    if (self.playdeck?.getPlayersLeft())! <= 1 {
                        self.finishHand()
                    }
                    else {
                        self.playerStrength()
                    }
                }
                else {
                    if (self.resetBool == false) {
                        self.resetBool = true
                        
                        let cm = self.playdeck?.winType((self.playdeck?.winner().strength)!)
                        
                        self.playdeck?.addChips(self.pot, (self.playdeck?.winner().name)!)
                        self.balanceLabel?.text = "$"+String((self.playdeck?.getPlayer().chips)!)
                        
                        
                        let alert = SKLabelNode(fontNamed: "Arial")
                        alert.text =  "Winner is \(self.playdeck?.winner().name ?? "") winning $\(self.pot) with the \(CardToStr((self.playdeck?.winner().hand)!)) with a hand of a \(String(describing: cm!))!"
                        alert.fontSize = 20
                        alert.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
                        alert.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
                        alert.fontColor = SKColor.white
                        alert.position = CGPoint(x: 0, y: 30)
                        alert.zPosition = 100
                        alert.lineBreakMode = NSLineBreakMode.byWordWrapping
                        alert.numberOfLines = 3
                        alert.preferredMaxLayoutWidth = CGFloat(300)
                        
                        let background = SKShapeNode(rect: CGRect(origin: CGPoint(x: -200, y: -32), size: CGSize(width: 400, height: 125)), cornerRadius: CGFloat(15))
                        background.zPosition = 99
                        background.name = "alert"
                        background.fillColor = UIColor.red
                        
                        
                        background.addChild(alert)
                        self.animateLabel([background])
                        self.addChild(background)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
                            if let child = self.childNode(withName: "alert") as? SKShapeNode {
                                child.removeFromParent()
                            }
                            self.reset()
                        }
                    }
                }
            }
        }
        
        //fold handled by shake
        
        bet = self.childNode(withName: "bet") as? BetNode
        
        bet!.selectedHandler = {
            if !self.alertBool && !self.resetBool{
                //                self.balance = self.balance - 10
                //                self.balanceLabel?.text = "$"+String(self.balance)
                
                if self.gamePos == 1 {
                    self.flop()
                    self.gamePos+=1
                    
                    let newBet = 10 * self.playdeck!.getPlayersLeft() //Bet added
                    self.pot = self.pot + newBet
                    self.potSize?.text = String(self.pot)
                    self.playdeck?.betChips(10)
                    self.updateLabels()
                    
                    
                    if (self.playdeck?.getPlayersLeft())! <= 1 {
                        self.finishHand()
                    }
                    else {
                        self.playerStrength()
                    }
                }
                else if self.gamePos == 2 {
                    
                    self.turn()
                    self.gamePos += 1
                    
                    let newBet = 10 * self.playdeck!.getPlayersLeft() //Bet added
                    self.pot = self.pot + newBet
                    self.potSize?.text = String(self.pot)
                    self.playdeck?.betChips(10)
                    self.updateLabels()
                    
                    if (self.playdeck?.getPlayersLeft())! <= 1 {
                        self.finishHand()
                    }
                    else {
                        self.playerStrength()
                    }
                    
                }
                else if self.gamePos == 3{
                    
                    self.river()
                    self.gamePos += 1
                    
                    let newBet = 10 * self.playdeck!.getPlayersLeft() //Bet added
                    self.pot = self.pot + newBet
                    self.potSize?.text = String(self.pot)
                    self.playdeck?.betChips(10)
                    self.updateLabels()
                    
                    if (self.playdeck?.getPlayersLeft())! <= 1 {
                        self.finishHand()
                    }
                    else {
                        self.playerStrength()
                    }
                }
                else {
                    if (self.resetBool == false) {
                        let newBet = 10 * self.playdeck!.getPlayersLeft()
                        self.pot = self.pot + newBet
                        self.potSize?.text = String(self.pot)
                        self.playdeck?.betChips(10)
                        self.updateLabels()
                        
                        self.resetBool = true
                        
                        let cm = self.playdeck?.winType((self.playdeck?.winner().strength)!)
                        
                        
                        self.playdeck?.addChips(self.pot, (self.playdeck?.winner().name)!)
                        self.updateLabels()
                        
                        let alert = SKLabelNode(fontNamed: "Arial")
                        alert.text =  "Winner is \(self.playdeck?.winner().name ?? "") winning $\(self.pot) with the \(CardToStr((self.playdeck?.winner().hand)!)) with a hand of a \(String(describing: cm!))!"
                        alert.fontSize = 20
                        alert.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
                        alert.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
                        alert.fontColor = SKColor.white
                        alert.position = CGPoint(x: 0, y: 30)
                        alert.zPosition = 100
                        alert.lineBreakMode = NSLineBreakMode.byWordWrapping
                        alert.numberOfLines = 3
                        alert.preferredMaxLayoutWidth = CGFloat(300)
                        
                        let background = SKShapeNode(rect: CGRect(origin: CGPoint(x: -200, y: -32), size: CGSize(width: 400, height: 125)), cornerRadius: CGFloat(15))
                        background.zPosition = 99
                        background.name = "alert"
                        background.fillColor = UIColor.red
                        
                        
                        background.addChild(alert)
                        self.animateLabel([background])
                        self.addChild(background)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
                            if let child = self.childNode(withName: "alert") as? SKShapeNode {
                                child.removeFromParent()
                            }
                            self.reset()
                        }
                    }
                }
                
            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func updateLabels() {
        self.balanceLabel?.text = "$"+String((self.playdeck?.getPlayer().chips)!)
        self.cpu1Label?.text = "$"+String((self.playdeck?.getChips("CPU1"))!)
        self.cpu2Label?.text = "$"+String((self.playdeck?.getChips("CPU2"))!)
        self.cpu3Label?.text = "$"+String((self.playdeck?.getChips("CPU3"))!)
    }
    
    func reset() {
        
        pot = 0
        if let child = self.childNode(withName: "card1") as? SKSpriteNode {
            child.removeFromParent()
        }
        if let child = self.childNode(withName: "card2") as? SKSpriteNode {
            child.removeFromParent()
        }
        potSize?.text = String(pot)
        for i in 1...5 {
            let name = "cardTable" + String(i)
            if let child = self.childNode(withName: name) as? SKSpriteNode {
                child.removeFromParent()
            }
        }
        game()
        //        playdeck?.reset()
        //        humanPlayer = getPlayer()
        
    }
    
    func playerStrength() {
        alertBool = true
        let alert1 = SKLabelNode(fontNamed: "Arial")
        alert1.text =  "How strong do you think your hand is?"
        alert1.fontSize = 20
        alert1.fontColor = SKColor.white
        alert1.position = CGPoint(x: 0, y: 40)
        alert1.zPosition = 100
        alert1.name = "alertt"
        let background1 = SKShapeNode(rect: CGRect(origin: CGPoint(x: -190, y: -32), size: CGSize(width: 380, height: 125)), cornerRadius: CGFloat(15))
        //        let background1 = SKShapeNode(rect: CGRect(origin: CGPoint(x: -400, y: -190), size: CGSize(width: 800, height: 380)), cornerRadius: CGFloat(15))
        background1.zPosition = 99
        background1.name = "stren"
        background1.fillColor = UIColor(red: 0, green: 100, blue: 0, alpha: 1)
        
        let alert2 = SKLabelNode(fontNamed: "Arial")
        alert2.text =  "Check Strength"
        alert2.fontSize = 20
        alert2.fontColor = SKColor.white
        alert2.position = CGPoint(x: 0, y: -160)
        alert2.zPosition = 100
        let buttonCancel = TouchableSpriteNode(rect: CGRect(origin: CGPoint(x: -100, y: -190), size: CGSize(width: 200, height: 70)), cornerRadius: CGFloat(15))
        buttonCancel.fillColor = UIColor.red
        buttonCancel.zPosition = 99
        buttonCancel.addChild(alert2)
        //buttonCancel.position = CGPoint(x: 0, y: -100)
        buttonCancel.isUserInteractionEnabled = true
        buttonCancel.name = "can"
        
        
        
        let val2 = SKLabelNode(fontNamed: "Arial")
        val2.text =  "0-140"
        val2.fontSize = 22
        val2.fontColor = SKColor.white
        val2.position = CGPoint(x: 0, y: 5)
        val2.zPosition = 102
        val2.name = "val2"
        
        let val = SKLabelNode(fontNamed: "Arial")
        val.text =  "30"
        val.fontSize = 25
        val.fontColor = SKColor.white
        val.position = CGPoint(x: 0, y: -20)
        val.zPosition = 102
        val.name = "val"
        
        let plus = SKLabelNode(fontNamed: "Arial")
        plus.text =  "+"
        plus.fontSize = 25
        plus.fontColor = SKColor.white
        plus.position = CGPoint(x: 50, y: -22)
        plus.zPosition = 102
        
        let minus = SKLabelNode(fontNamed: "Arial")
        minus.text =  "-"
        minus.fontSize = 25
        minus.fontColor = SKColor.white
        minus.position = CGPoint(x: -50, y: -20)
        minus.zPosition = 102
        
        let buttonPlus = TouchableSpriteNode(rect: CGRect(origin: CGPoint(x: 35, y: -27), size: CGSize(width: 30, height: 30)), cornerRadius: CGFloat(15))
        buttonPlus.fillColor = UIColor.red
        buttonPlus.zPosition = 101
        buttonPlus.addChild(plus)
        //buttonCancel.position = CGPoint(x: 0, y: -100)
        buttonPlus.isUserInteractionEnabled = true
        buttonPlus.name = "plus"
        
        buttonPlus.selectedHandler = {
            var amt = Int(val.text!)
            if (amt! <= 140) {
                amt!+=1
                val.text = String(amt!)
            }
            
        }
        
        let buttonMinus = TouchableSpriteNode(rect: CGRect(origin: CGPoint(x: -65, y: -27), size: CGSize(width: 30, height: 30)), cornerRadius: CGFloat(15))
        buttonMinus.fillColor = UIColor.red
        buttonMinus.zPosition = 101
        buttonMinus.addChild(minus)
        
        //buttonCancel.position = CGPoint(x: 0, y: -100)
        buttonMinus.isUserInteractionEnabled = true
        buttonMinus.name = "minus"
        
        buttonMinus.selectedHandler = {
            var amt = Int(val.text!)
            if (amt! > 0) {
                amt!-=1
                val.text = String(amt!)
            }
            
        }
        
        buttonCancel.selectedHandler = {
//
            if let child = self.childNode(withName: "stren")?.childNode(withName: "alertt") as? SKLabelNode {
                child.removeFromParent()
            }
//            if let child = self.childNode(withName: "stren")?.childNode(withName: "val") as? SKLabelNode {
//                child.removeFromParent()
//            }
            let curr = val.text
            val.text = "You guessed: " + curr!
            if let child = self.childNode(withName: "stren")?.childNode(withName: "val2") as? SKLabelNode {
                child.removeFromParent()
            }
            if let child = self.childNode(withName: "stren")?.childNode(withName: "plus") as? SKShapeNode {
                child.removeFromParent()
            }
            if let child = self.childNode(withName: "stren")?.childNode(withName: "minus") as? SKShapeNode {
                child.removeFromParent()
            }
            if let child = self.childNode(withName: "stren")?.childNode(withName: "can") as? SKShapeNode {
                child.removeFromParent()
            }
            
            let alert3 = SKLabelNode(fontNamed: "Arial")
            alert3.text =  "Your strength is \(String(describing: (self.playdeck?.getPlayer().strength)!))"
            alert3.fontSize = 22
            alert3.fontColor = SKColor.white
            alert3.position = CGPoint(x: 0, y: 50)
            alert3.zPosition = 100
            
            let alert4 = SKLabelNode(fontNamed: "Arial")
            alert4.text =  "You have a \(String(describing: (self.playdeck?.winType((self.playdeck?.getPlayer().strength)!))!))"
            alert4.fontSize = 22
            alert4.fontColor = SKColor.white
            alert4.position = CGPoint(x: 0, y: 20)
            alert4.zPosition = 100
            
            background1.addChild(alert3)
            background1.addChild(alert4)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                if let child = self.childNode(withName: "stren") as? SKShapeNode {
                    child.removeFromParent()
                    self.alertBool = false
                }
            }
            
            
        }
        
        background1.addChild(val)
        background1.addChild(val2)
//        background1.addChild(plus)
//        background1.addChild(minus)
        background1.addChild(buttonPlus)
        background1.addChild(buttonMinus)
        
        
        background1.addChild(buttonCancel)
        background1.addChild(alert1)
        animateLabel([background1])
        self.addChild(background1)
    }
    
    func shake() {
        if (self.resetBool == false && !self.alertBool) {
            print("FOLD")
            self.playdeck?.foldPlayer()
            self.finishHand()
        }
    }
    
    func finishHand() {
        if self.gamePos == 1 {
            self.flop()
            self.gamePos+=1
        }
        if self.gamePos == 2 {
            self.turn()
            self.gamePos += 1
        }
        if self.gamePos == 3{
            self.river()
            self.gamePos += 1
        }
        if (self.resetBool == false) {
            self.resetBool = true
            
            let cm = self.playdeck?.winType((self.playdeck?.winner().strength)!)
            
            let alert = SKLabelNode(fontNamed: "Arial")
            
            
            self.playdeck?.addChips(self.pot, (self.playdeck?.winner().name)!)
            //            self.balance = self.balance + self.pot
            self.balanceLabel?.text = "$"+String((self.playdeck?.getPlayer().chips)!)
            
            
            
            
            
            alert.text =  "Winner is \(self.playdeck?.winner().name ?? "") winning $\(self.pot) with the \(CardToStr((self.playdeck?.winner().hand)!)) with a hand of a \(String(describing: cm!))!"
            alert.fontSize = 20
            alert.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
            alert.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            alert.fontColor = SKColor.white
            alert.position = CGPoint(x: 0, y: 30)
            alert.zPosition = 100
            alert.lineBreakMode = NSLineBreakMode.byWordWrapping
            alert.numberOfLines = 3
            alert.preferredMaxLayoutWidth = CGFloat(300)
            
            let background = SKShapeNode(rect: CGRect(origin: CGPoint(x: -200, y: -32), size: CGSize(width: 400, height: 125)), cornerRadius: CGFloat(15))
            background.zPosition = 99
            background.name = "alert"
            background.fillColor = UIColor.red
            
            
            background.addChild(alert)
            animateLabel([background])
            self.addChild(background)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                if let child = self.childNode(withName: "alert") as? SKShapeNode {
                    child.removeFromParent()
                }
                self.reset()
            }
            
        }
    }
    
    
    func game() {
        playdeck?.reset()
        humanPlayer = getPlayer()
        let cardone = humanPlayer?.hand[0]
        let cardtwo = humanPlayer?.hand[1]
        let string1 = "card-" + CardToTypeString(card: cardone!) + "-" + CardToSuitString(card: cardone!)
        let string2 = "card-" + CardToTypeString(card: cardtwo!) + "-" + CardToSuitString(card: cardtwo!)
        
        card1 = SKSpriteNode(imageNamed: string1)
        
        if  (CardToSuitString(card: cardone!) == "hearts" || CardToSuitString(card: cardone!) == "diamonds"){
            card1?.color = UIColor.red
            card1?.colorBlendFactor = 0.5
        }
        else {
            card1?.color = UIColor.black
            card1?.colorBlendFactor = 0.5
        }
        card2 = SKSpriteNode(imageNamed: string2)
        
        
        if  (CardToSuitString(card: cardtwo!) == "hearts" || CardToSuitString(card: cardtwo!) == "diamonds"){
            card2?.color = UIColor.red
            card2?.colorBlendFactor = 0.5
        }
        else {
            card2?.color = UIColor.black
            card2?.colorBlendFactor = 0.5
        }
        
        card1?.position = CGPoint(x: -25, y: -75)
        card1?.size = CGSize(width: 65, height: 80)
        card2?.position = CGPoint(x: 25, y: -75)
        card2?.size = CGSize(width: 65, height: 80)
        
        animateNodes([card1!, card2!])
        
        addChild(card1!)
        card1?.name = "card1"
        addChild(card2!)
        card2?.name = "card2"
        self.gamePos = 1
        resetBool = false
    }
    
    func animateNodes(_ nodes: [SKSpriteNode]) {
        for (_, node) in nodes.enumerated() {
            let scaleUpAction = SKAction.scale(to: 1.5, duration: 0.3)
            let scaleDownAction = SKAction.scale(to: 1, duration: 0.3)
            let scaleActionSequence = SKAction.sequence([scaleUpAction, scaleDownAction])
            node.run(scaleActionSequence)
        }
    }
    
    func animateLabel(_ nodes: [SKShapeNode]) {
        for (_, node) in nodes.enumerated() {
            let scaleUpAction = SKAction.scale(to: 1.2, duration: 0.3)
            let scaleDownAction = SKAction.scale(to: 1, duration: 0.3)
            let scaleActionSequence = SKAction.sequence([scaleUpAction, scaleDownAction])
            node.run(scaleActionSequence)
        }
    }
    
    func flop() {
        playdeck!.flop()
        let cards = playdeck?.sharedCards
        var i = -100
        var j = 1
        for card in cards! {
            let string = "card-" + CardToTypeString(card: card) + "-" + CardToSuitString(card: card)
            let card1 = SKSpriteNode(imageNamed: string)
            
            if  (CardToSuitString(card: card) == "hearts" || CardToSuitString(card: card) == "diamonds"){
                card1.color = UIColor.red
                card1.colorBlendFactor = 0.5
            }
            else {
                card1.color = UIColor.black
                card1.colorBlendFactor = 0.5
            }
            
            card1.position = CGPoint(x: i, y: 130)
            card1.size = CGSize(width: 65, height: 80)
            addChild(card1)
            animateNodes([card1])
            card1.name = "cardTable" + String(j)
            i += 50
            j += 1
        }
    }
    
    func turn() {
        playdeck!.turn()
        let cards = playdeck?.sharedCards
        let string = "card-" + CardToTypeString(card: cards![3]) + "-" + CardToSuitString(card: cards![3])
        let card1 = SKSpriteNode(imageNamed: string)
        
        if  (CardToSuitString(card: cards![3]) == "hearts" || CardToSuitString(card: cards![3]) == "diamonds"){
            card1.color = UIColor.red
            card1.colorBlendFactor = 0.5
        }
        else {
            card1.color = UIColor.black
            card1.colorBlendFactor = 0.5
        }
        animateNodes([card1])
        card1.position = CGPoint(x: 50, y: 130)
        card1.size = CGSize(width: 65, height: 80)
        addChild(card1)
        card1.name = "cardTable4"
    }
    
    func river() {
        playdeck!.turn()
        let cards = playdeck?.sharedCards
        
        let string = "card-" + CardToTypeString(card: cards![4]) + "-" + CardToSuitString(card: cards![4])
        let card1 = SKSpriteNode(imageNamed: string)
        if  (CardToSuitString(card: cards![4]) == "hearts" || CardToSuitString(card: cards![4]) == "diamonds"){
            card1.color = UIColor.red
            card1.colorBlendFactor = 0.5
        }
        else {
            card1.color = UIColor.black
            card1.colorBlendFactor = 0.5
        }
        
        card1.position = CGPoint(x: 100, y: 130)
        card1.size = CGSize(width: 65, height: 80)
        animateNodes([card1])
        addChild(card1)
        card1.name = "cardTable5"
        
    }
    
    func CardToTypeString(card: Card) -> String {
        var str = ""
        
        switch card.type {
        case .ace:
            str = "ace"
        case .king:
            str = "king"
        case .queen:
            str = "queen"
        case .jack:
            str = "jack"
        case .ten:
            str = "10"
        case .nine:
            str = "9"
        case .eight:
            str = "8"
        case .seven:
            str = "7"
        case .six:
            str = "6"
        case .five:
            str = "5"
        case .four:
            str = "4"
        case .three:
            str = "3"
        case .two:
            str = "2"
        }
        
        return str
    }
    
    func CardToSuitString(card: Card) -> String {
        var str = ""
        
        switch card.suit {
        case .hearts:
            str = "hearts"
        case .spades:
            str = "spades"
        case .clubs:
            str = "clubs"
        case .diamonds:
            str = "diamonds"
        }
        
        return str
    }
    
    func getPlayer() -> Player {
        var j: Player = playdeck!.playerHands[0]
        for i in playdeck!.playerHands {
            if i.cpu == false {
                j = i
            }
        }
        return j;
    }
}


