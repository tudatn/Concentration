//
//  ViewController.swift
//  Concentration
//
//  Created by Tu Dat Nguyen on 2017-12-25.
//  Copyright © 2017 Think Deep. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // cannot use property observer for lazy var
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLable()
        }
    }
    
    private func updateFlipCountLable() {
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(game.flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    @IBOutlet private weak var scoreLable: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    func updateViewFromModel() {
//        flipCountLabel.text = "Flips: \(game.flipCount)"
        scoreLable.text = "Scores: \(game.score)"
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }

    private let emojiTheme = [
        "sports":["⚽️", "🎾", "🎱", "🏉", "🏀", "🏓"],
        "faces":["😀", "😂", "😝", "😎", "😍", "😩"],
        "numbers":["㉒", "㉜", "㊹", "⑰", "㊾", "⑱"],
        "fruits":["🍅", "🍇", "🍒", "🥝", "🍌", "🍍", "🍓", "🍑", "🍈"],
        "letters":["a", "b", "c", "z", "g", "t", "e"],
        "vehicles":["🚚", "🚑", "🚙", "🚲", "✈️", "🚒", "🚡"],
        "animals":["🦅", "🐸", "🙈", "😸", "🦓", "🐓", "🐍", "🐉", "🐞", "🕊"]
    ]
    
    private var defaultTheme: String {
        get {
            let gameTheme = Array(emojiTheme.keys)
            return gameTheme[gameTheme.count.arc4random]
        }
        set {
            emoji = [:]
            emojiChoices = emojiTheme[newValue]!
        }
    }
    
    private lazy var emojiChoices = emojiTheme[defaultTheme]!

    private var emoji = [Card:String]()
    
    func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomIndex = emojiChoices.count.arc4random
            emoji[card] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card] ?? "?"
    }
    
    @IBAction func resetGame() {
        let gameTheme = Array(emojiTheme.keys)
        defaultTheme = gameTheme[gameTheme.count.arc4random]
        game.resetCards()
        updateViewFromModel()
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }
        else {
            return 0
        }
    }
}
