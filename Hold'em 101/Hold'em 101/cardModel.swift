//
//  cardModel.swift
//  Hold'em 101
//
//  Created by Devin Craig on 3/14/21.
//

import Foundation

enum CardType: CaseIterable {
    case ace
    case king
    case queen
    case jack
    case ten
    case nine
    case eight
    case seven
    case six
    case five
    case four
    case three
    case two
}

class Slider {
    var minimumValue = 0
    var maximumValue = 140
}

enum CardSuit: CaseIterable {
    case hearts
    case spades
    case clubs
    case diamonds
}

struct Card: Equatable {
    var type: CardType
    var suit: CardSuit
}

func CardToStr(_ cs: [Card]) -> String {
    var s = ""
    var c = cs[0]
    
    if (c.type == CardType.ace) {
        s += "Ace of "
    } else if (c.type == CardType.king) {
        s += "King of "
    } else if (c.type == CardType.queen) {
        s += "Queen of "
    } else if (c.type == CardType.jack) {
        s += "Jack of "
    } else if (c.type == CardType.ten) {
        s += "Ten of "
    } else if (c.type == CardType.nine) {
        s += "Nine of "
    } else if (c.type == CardType.eight) {
        s += "Eight of "
    } else if (c.type == CardType.seven) {
        s += "Seven of "
    } else if (c.type == CardType.six) {
        s += "Six of "
    } else if (c.type == CardType.five) {
        s += "Five of "
    } else if (c.type == CardType.four) {
        s += "Four of "
    } else if (c.type == CardType.three) {
        s += "Three of "
    } else if (c.type == CardType.two) {
        s += "Two of "
    } else {
        
    }
    
    if (c.suit == CardSuit.clubs) {
        s += "Clubs"
    } else if (c.suit == CardSuit.diamonds) {
        s += "Diamonds"
    } else if (c.suit == CardSuit.hearts) {
        s += "Hearts"
    } else if (c.suit == CardSuit.spades) {
        s += "Spades"
    }
    else {
        
    }
    
    s += " and the "
    
    c = cs[1]
    
    if (c.type == CardType.ace) {
        s += "Ace of "
    } else if (c.type == CardType.king) {
        s += "King of "
    } else if (c.type == CardType.queen) {
        s += "Queen of "
    } else if (c.type == CardType.jack) {
        s += "Jack of "
    } else if (c.type == CardType.ten) {
        s += "Ten of "
    } else if (c.type == CardType.nine) {
        s += "Nine of "
    } else if (c.type == CardType.eight) {
        s += "Eight of "
    } else if (c.type == CardType.seven) {
        s += "Seven of "
    } else if (c.type == CardType.six) {
        s += "Six of "
    } else if (c.type == CardType.five) {
        s += "Five of "
    } else if (c.type == CardType.four) {
        s += "Four of "
    } else if (c.type == CardType.three) {
        s += "Three of "
    } else if (c.type == CardType.two) {
        s += "Two of "
    } else {
        
    }
    
    if (c.suit == CardSuit.clubs) {
        s += "Clubs"
    } else if (c.suit == CardSuit.diamonds) {
        s += "Diamonds"
    } else if (c.suit == CardSuit.hearts) {
        s += "Hearts"
    } else if (c.suit == CardSuit.spades) {
        s += "Spades"
    }
    else {
        
    }
    
    return s
}

func opttoint(_ opt: Int?) -> Int {
    return opt!
}

struct Player {
    //true is cpu
    var cpu: Bool
    var hand: [Card]
    var chips: Int
    var strength: Int
    var name: String
    // fold = true
    var fold: Bool = false
    
    mutating func updateStrength(st: Int) {
        self.strength = st
    }
    
    mutating func updateFold() {
        fold = true
    }
}

class cardModel {
    @Published var cards: [Card]
    var strength: Int
    var round: Int
    var highCard: Int
    
    
    init(cs: [Card], r: Int) {
        cards = cs
        strength = 0
        highCard = 0
        round = r
        strength = cardStrength()
    }
    
    func reset() { //Same as init? Can probably change idk
        cards = []
        strength = 0
        highCard = 0
    }
    
    func cardStrength() -> Int { //calc strength
        
        strength = 0
        highCard = 0
        
        if round >= 0 {
           
            
            //High card
            for i in 0...cards.count-1 {
           
                if (rank(c:cards[i]) > highCard) {
                    highCard = rank(c:cards[i])
                    strength = highCard
                }
            
            }
            
            let pair = isPair(cs: cards)
            if pair {
                strength = 14+highCard
//                print("pair")
            }
            
            if round >= 1 {
            
                let twopair = is2Pair(cs: cards)
                if twopair {
                    strength = 28+highCard
//                    print("twopair")
                }
                
                let threekind = is3kind(cs: cards)
                if threekind {
                    strength = 42+highCard
//                    print("3 kind")
                }
                
                let straight = isStraight(cs: cards)
                if(straight){
                    strength = 56+highCard
//                    print("str")
                }
                
                let flush = isFlush(cs: cards)
                if (flush) {
                    strength = 70+highCard
//                    print("flu")
                }
                
                let fullHouse = isFullHouse(cs: cards)
                if fullHouse {
                    strength = 84+highCard
//                    print("fullh")
                }
                
                let isfour = is4kind(cs: cards)
                if(isfour){
                    strength = 98+highCard
//                    print("4")
                }
            }
        }
        

        
        
        return strength
        
        
    }
    func is4kind(cs: [Card]) -> Bool {
        
        let sorted =  cs
        
        var valueArray: [Int] = []
        for card in sorted {
            valueArray.append(rank(c: card))
        }
        
        let countedSet = NSCountedSet(array: valueArray)
        
        for i in valueArray {
            if countedSet.count(for: i) == 4 {
                highCard = i
                return true
            }
        }
        return false
    }
    
    
    func is3kind(cs: [Card]) -> Bool {
        
        let sorted =  cs
        
        var valueArray: [Int] = []
        for card in sorted {
            valueArray.append(rank(c: card))
        }
        
        let countedSet = NSCountedSet(array: valueArray)
        
        for i in valueArray {
            if countedSet.count(for: i) == 3 {
                highCard = i
                return true
            }
        }
        return false
    }
    
    func is2Pair(cs: [Card]) -> Bool {
        
        let sorted =  cs
        
        var valueArray: [Int] = []
        for card in sorted {
            valueArray.append(rank(c: card))
        }
        
        let countedSet = NSCountedSet(array: valueArray)
        
        var firstpair = false
        var val1: Int = 0
        
        for i in valueArray {
            if countedSet.count(for: i) == 2 && i != val1 {
                if firstpair {
                    highCard = max(i,val1)
                    return true
                }
                else {
                    firstpair = true
                    val1 = i
                }
            }
        }
        return false
    }
    
    func isFullHouse(cs: [Card]) -> Bool {
        
        let sorted =  cs
        
        var valueArray: [Int] = []
        for card in sorted {
            valueArray.append(rank(c: card))
        }
        
        let countedSet = NSCountedSet(array: valueArray)
        
        var firstpair = false
        var triples = false
        var val1 = 0
        
        for i in valueArray {
            if countedSet.count(for: i) == 2 && i != val1{
                if triples {
                    highCard = max(i,val1)
                    return true
                }
                firstpair = true
                val1 = i
            }
            if countedSet.count(for: i) == 3 && i != val1{
                if firstpair {
                    highCard = max(i,val1)
                    return true
                }
                triples = true
                val1 = i
            }
        }
        return false
    }
    
    func isPair(cs: [Card]) -> Bool {
        
        let sorted =  cs
        
        var valueArray: [Int] = []
        for card in sorted {
            valueArray.append(rank(c: card))
        }
        
        let countedSet = NSCountedSet(array: valueArray)
        
        for i in valueArray {
            if countedSet.count(for: i) == 2 {
                highCard = i
                return true
            }
        }
        return false
    }
    
    func isStraight(cs: [Card]) -> Bool {
        let temp = cs
        if round == 1 {
            var valueArray: [Int] = []
            for card in temp {
                valueArray.append(rank(c: card))
            }
            valueArray = valueArray.sorted()
            //ace
            if valueArray.contains(13) {
                for i in 1...4 {
                    if (!valueArray.contains(i)) {
                        break
                    }
                    else {
                        if i == 4 {
                            highCard = 4
                            return true
                        }
                    }
                }
                for i in 9...12 {
                    if (!valueArray.contains(i)) {
                        return false
                    }
                }
                highCard = 13
                return true
            }
            //no ace
            else {
                var tester = valueArray[0] + 1
                for i in 1...temp.count-1 {
                    if (valueArray.contains(tester)) {
                        if i == temp.count - 1 {
                            highCard = tester
                            return true
                        }
                        tester = tester + 1
                    }
                    else {
                        break
                    }
                }
                
                
                return false
            }
        }
        
        if round == 2 {
            
            var valueArray: [Int] = []
            for card in temp {
                valueArray.append(rank(c: card))
            }
            valueArray = valueArray.sorted()
            
            var tester = valueArray[0] + 1
            for i in 1...valueArray.count-2 {
                if (valueArray.contains(tester)) {
                    if i == temp.count - 2 {
                        highCard = tester
                        return true
                    }
                    tester = tester + 1
                }
                else {
                    break
                }
            }
            tester = valueArray[2] + 1
            for i in 2...temp.count-1 {
                if (valueArray.contains(tester)) {
                    if i == temp.count - 2 {
                        highCard = tester
                        return true
                    }
                    tester = tester + 1
                }
                else {
                    break
                }
            }
            if valueArray.contains(13) {
                for i in 1...4 {
                    if (!valueArray.contains(i)) {
                        break
                    }
                    else {
                        if i == 4 {
                            highCard = 4
                            return true
                        }
                    }
                }
                for i in 9...12 {
                    if (!valueArray.contains(i)) {
                        return false
                    }
                }
                highCard = 13
                return true
            }
            return false
        }
        
        if round == 3 {
            
            var valueArray: [Int] = []
            for card in temp {
                valueArray.append(rank(c: card))
            }
            valueArray = valueArray.sorted()
            
            var tester = valueArray[0] + 1
            for i in 1...temp.count-3 {
                if (valueArray.contains(tester)) {
                    if i == temp.count - 3 {
                        highCard = tester
                        return true
                    }
                    tester = tester + 1
                }
                else {
                    break
                }
            }
            tester = valueArray[1] + 1
            for i in 2...temp.count-2 {
                if (valueArray.contains(tester)) {
                    if i == temp.count - 2 {
                        highCard = tester
                        return true
                    }
                    tester = tester + 1
                }
                else {
                    break
                }
            }
            tester = valueArray[2] + 1
            for i in 3...temp.count-1 {
                if (valueArray.contains(tester)) {
                    if i == temp.count - 1 {
                        highCard = tester
                        return true
                    }
                    tester = tester + 1
                }
                else {
                    break
                }
            }
            if valueArray.contains(13) {
                for i in 1...4 {
                    if (!valueArray.contains(i)) {
                        break
                    }
                    else {
                        if i == 4 {
                            highCard = 4
                            return true
                        }
                    }
                }
                for i in 9...12 {
                    if (!valueArray.contains(i)) {
                        return false
                    }
                }
                highCard = 13
                return true
            }
            return false
        }
        
        return false
    }
    
    
   
   
    
    func rank(c: Card) -> Int { //get rank of card
        if (c.type == CardType.ace) {
            return 13
        } else if (c.type == CardType.king) {
            return 12
        } else if (c.type == CardType.queen) {
            return 11
        } else if (c.type == CardType.jack) {
            return 10
        } else if (c.type == CardType.ten) {
            return 9
        } else if (c.type == CardType.nine) {
            return 8
        } else if (c.type == CardType.eight) {
            return 7
        } else if (c.type == CardType.seven) {
            return 6
        } else if (c.type == CardType.six) {
            return 5
        } else if (c.type == CardType.five) {
            return 4
        } else if (c.type == CardType.four) {
            return 3
        } else if (c.type == CardType.three) {
            return 2
        } else if (c.type == CardType.two) {
            return 1
        } else {
            return -1 //idk
        }
        
    }
    
    func isFlush(cs: [Card]) -> Bool {
        
        var hcount = 0
        var scount = 0
        var dcount = 0
        var ccount = 0
        
        for i in 0...cs.count-1 {
            if (cs[i].suit == CardSuit.hearts) {
                hcount = hcount + 1
            } else if (cs[i].suit == CardSuit.spades) {
                scount = scount + 1
            } else if (cs[i].suit == CardSuit.diamonds) {
                dcount = dcount + 1
            } else { //clubs
                ccount = ccount + 1
            }
        }
        highCard = 0
        for i in 0...cards.count-1 {
       
            if (rank(c:cards[i]) > highCard) {
                highCard = rank(c:cards[i])
            }
        
        }
        if (hcount >= 5 || scount >= 5 || dcount >= 5 || ccount >= 5) {
            
            return true
        }
        
        return false
    }
    
}

class deck: ObservableObject {
    @Published var availableCards: [Card]
    @Published var playerHands: [Player]
    @Published var sharedCards: [Card]
    @Published var players: Int
    @Published var round: Int = 0
    @Published var playersLeft: Int
    var tutorial: Bool
    
    init(numplayers: Int, tut: Bool, buyIn: Int) {
        availableCards = resetMain()
        playerHands = []
        sharedCards = []
        playersLeft = numplayers
        players = numplayers
        tutorial = tut
        round = 0
        hands(buyin: buyIn)
    }
    
    func addChips(_ chips: Int, _ str: String) {
//        print(str + "won \(chips)")
        for i in 0...playerHands.count - 1 {
            if playerHands[i].name == str {
                playerHands[i].chips += chips
            }
        }
    }
    
    func betChips(_ chips: Int) {
        for i in 0...playerHands.count - 1 {
            if playerHands[i].fold == false {
                playerHands[i].chips -= chips
            }
        }
    }
    
    func newGame(numplayers: Int, tut: Bool, buyIn: Int) {
        players = numplayers
        playersLeft = numplayers
        tutorial = tut
        playerHands = []
        sharedCards = []
        availableCards = reset1()
        round = 0
        hands(buyin: buyIn)
    }
    
    func getPlayersLeft() -> Int {
        return playersLeft
    }
    
    func hands(buyin: Int) {
//        if tutorial {
            let humanhand: [Card] =  twoCards()//twoCardsTutorial()
            //print(humanhand)
            let cModel1 = cardModel(cs: humanhand, r: round)
            let playerhand = Player(cpu: false, hand: humanhand, chips: buyin, strength: cModel1.cardStrength(), name: "YOU")
            playerHands.append(playerhand)
            //print(cModel1.cardStrength())
            
            for i in 0..<players - 1 {
                let hand: [Card] = twoCards()
                
                let cModel = cardModel(cs: hand, r:round)
                let player = Player(cpu: true, hand: hand, chips: buyin, strength: cModel.cardStrength(), name: "CPU\(i+1)")
                playerHands.append(player)
            }
    }
    
    func handsReset(buyin: [(String, Int)]) {
//        if tutorial {
        for player in buyin {
            if player.0 == "YOU" {
                let humanhand: [Card] =  twoCards()//twoCardsTutorial()
                //print(humanhand)
                let cModel1 = cardModel(cs: humanhand, r: round)
                let playerhand = Player(cpu: false, hand: humanhand, chips: player.1, strength: cModel1.cardStrength(), name: "YOU")
                playerHands.append(playerhand)
            }
            else {
                let hand: [Card] = twoCards()
                
                let cModel = cardModel(cs: hand, r:round)
                var player2 = Player(cpu: true, hand: hand, chips: player.1, strength: cModel.cardStrength(), name: player.0)
                if player.1 <= 0 {
                    player2.updateFold()
                }
                playerHands.append(player2)
            }
        }
    }
    
    func twoCards() -> [Card] {
        var cards: [Card] = []
        let c1 = availableCards.randomElement()!
        availableCards.remove(at: availableCards.firstIndex(of: c1)!)
        let c2 = availableCards.randomElement()!
        availableCards.remove(at: availableCards.firstIndex(of: c2)!)
        cards.append(c1)
        cards.append(c2)
        return cards
    }
    
    func getPlayer() -> Player {
        var j: Player = playerHands[0]
        for i in playerHands {
            if i.cpu == false {
                j = i
            }
        }
        return j;
    }
    
    func flop() {
        let c1 = availableCards.randomElement()!
        availableCards.remove(at: availableCards.firstIndex(of: c1)!)
        let c2 = availableCards.randomElement()!
        availableCards.remove(at: availableCards.firstIndex(of: c2)!)
        let c3 = availableCards.randomElement()!
        availableCards.remove(at: availableCards.firstIndex(of: c3)!)
        
        sharedCards.append(c1)
        sharedCards.append(c2)
        sharedCards.append(c3)
        round+=1
        for i in 0...playerHands.count - 1 {
            var h = playerHands[i].hand
            h.append(contentsOf: sharedCards)
            
            let cModel = cardModel(cs: h, r:round)
            //print(round)
            playerHands[i].updateStrength(st: cModel.cardStrength())
            //playerHands[i].strength = cModel.cardStrength()
            
            if playerHands[i].cpu && playerHands[i].strength < 14 && playersLeft > 1 && !playerHands[i].fold{
                playerHands[i].updateFold()
//                print("\(playerHands[i].name) will fold")
                playersLeft -= 1
            }
        }
    }
    
    func turn() {
        let c1 = availableCards.randomElement()!
        availableCards.remove(at: availableCards.firstIndex(of: c1)!)
        sharedCards.append(c1)
        round+=1
        
        for i in 0...playerHands.count - 1 {
            var h = playerHands[i].hand
            h.append(contentsOf: sharedCards)
            
            let cModel = cardModel(cs: h, r:round)
            //print(round)
            playerHands[i].updateStrength(st: cModel.cardStrength())
            //playerHands[i].strength = cModel.cardStrength()
            
            if playerHands[i].cpu && playerHands[i].strength < 14 && playersLeft > 1 && !playerHands[i].fold {
                playerHands[i].updateFold()
//                print("wtfffff")
//                print("\(playerHands[i].name) will fold")
                playersLeft -= 1
            }
        }
    }
    
    func winner() -> Player {
        var strength = 0
        var player = playerHands[0]
        for hands in playerHands {
            
            if !hands.fold {
                if hands.strength > strength || (hands.strength == strength && !hands.cpu ) {
                    player = hands
                    strength = hands.strength
                }
                
                //handle tie then need deeper check
            }
        }
        
//        print("winnner is \(player.name)")
        return player
    }
    
    func getChips(_ str: String) -> Int {
        for i in 0...playerHands.count - 1 {
            if playerHands[i].name == str {
                return playerHands[i].chips
            }
            
        }
        return 0
    }
    
    func foldPlayer() {
        for i in 0...playerHands.count - 1 {
            if !playerHands[i].cpu {
                playerHands[i].updateFold()
                playersLeft -= 1
                break
            }
            
        }
    }
    
    func winType(_ strength: Int) -> String {
        if strength < 14 {
            return "High Card"
        }
        else if strength < 28 {
           return "Pair"
        }
        else if strength < 42 {
           return "Two Pair"
        }
        else if strength < 56 {
           return "Three of a Kind"
        }
        else if strength < 70 {
           return "Straight"
        }
        else if strength < 84 {
           return "Flush"
        }
        else if strength < 98 {
            return "Full House"
        }
        else if strength < 112 {
           return "Four of a Kind"
        }
        else if strength < 126 {
           return "Straight Flush"
        }
        else if strength < 140 {
           return "Royal Flush"
        }
        return "High Card"
    }
    
    //    func twoCardsTutorial() -> [Card] {
    //        var cards: [Card] = []
    //
    //        //give them certain cards
    //
    //        return cards
    //    }
    
    func reset1() -> [Card] {
        var cards: [Card] = []
        
        for type in CardType.allCases {
            for suit in CardSuit.allCases {
                let card = Card(type: type, suit: suit)
                
                cards.append(card)
            }
        }
        return cards
    }
    
    func reset() {
        var cards: [Card] = []
        
        for type in CardType.allCases {
            for suit in CardSuit.allCases {
                let card = Card(type: type, suit: suit)
                
                cards.append(card)
            }
        }
        availableCards = cards
        var passDown: [(String, Int)] = []
        for hand in playerHands {
            passDown.append((hand.name, hand.chips))
        }
        
        playerHands = []
        sharedCards = []
        playersLeft = 4
        round = 0
        
        handsReset(buyin: passDown)
        
    }
    
}

func resetMain() -> [Card] {
    var cards: [Card] = []
    
    for type in CardType.allCases {
        for suit in CardSuit.allCases {
            let card = Card(type: type, suit: suit)
            
            cards.append(card)
        }
    }
    return cards
}

