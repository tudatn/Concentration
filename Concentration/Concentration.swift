//
//  Concentration.swift
//  Concentration
//
//  Created by Tu Dat Nguyen on 2017-12-26.
//  Copyright © 2017 Think Deep. All rights reserved.
//

import Foundation

class Concentration {
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    var flipCount = 0
    
    var score = 0
    
    var usedCards = [Int]()
    
    func chooseCard(at index: Int) {
        flipCount += 1
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                }
                else {
                    if usedCards.contains(cards[matchIndex].identifier) {
                        score -= 1
                    }
                    else { usedCards += [cards[matchIndex].identifier] }
                    
                    if usedCards.contains(cards[index].identifier) {
                        score -= 1
                    } else { usedCards += [cards[index].identifier] }
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    func resetCards() {
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
            usedCards = []
            indexOfOneAndOnlyFaceUpCard = nil
            flipCount = 0
            score = 0
        }
        shuffleCards(with: cards.count)
    }
    
    init(numberOfPairsOfCards: Int) {
        let totalNumberOfCards = numberOfPairsOfCards * 2;
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        // Shuffle the cards
        shuffleCards(with: totalNumberOfCards)
    }
    
    func shuffleCards(with numberOfCards: Int) {
        for _ in 1...numberOfCards {
            let randomFirstIndex = Int(arc4random_uniform(UInt32(numberOfCards)))
            let randomSecondIndex = Int(arc4random_uniform(UInt32(numberOfCards)))
            let temporaryCard = cards[randomFirstIndex]
            cards[randomFirstIndex] = cards[randomSecondIndex]
            cards[randomSecondIndex] = temporaryCard
        }
    }
}
