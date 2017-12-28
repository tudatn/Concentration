//
//  Concentration.swift
//  Concentration
//
//  Created by Tu Dat Nguyen on 2017-12-26.
//  Copyright © 2017 Think Deep. All rights reserved.
//

import Foundation

class Concentration {
    var cards = [Card]()
    
    var indexOfOneAndOnlyFaceUpCard: Int?
    
    var flipCount = 0
    
    func chooseCard(at index: Int) {
        flipCount += 1
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                // either no cards or 2 cards are face up
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    func resetCards() {
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
            indexOfOneAndOnlyFaceUpCard = nil
            flipCount = 0
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        let totalNumberOfCards = numberOfPairsOfCards * 2;
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        // Shuffle the cards
        for _ in 1...numberOfPairsOfCards {
            let randomFirstIndex = Int(arc4random_uniform(UInt32(totalNumberOfCards)))
            let randomSecondIndex = Int(arc4random_uniform(UInt32(totalNumberOfCards)))
            swapCards(between: randomFirstIndex, and: randomSecondIndex)
        }
    }
    
    func swapCards(between firstIndex: Int, and secondIndex: Int) {
        let temporaryCard = cards[firstIndex]
        cards[firstIndex] = cards[secondIndex]
        cards[secondIndex] = temporaryCard
    }
}
