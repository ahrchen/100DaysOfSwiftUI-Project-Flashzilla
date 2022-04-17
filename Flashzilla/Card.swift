//
//  Card.swift
//  Flashzilla
//
//  Created by Raymond Chen on 4/13/22.
//

import Foundation

struct Card: Codable, Identifiable{
    var id = UUID()
    let prompt: String
    let answer: String
    
    static let savePath = FileManager.documentDirectory.appendingPathComponent("SavedCards")
    static let example = Card(prompt: "Who played the 13 Doctor in Doctor Who?", answer: "Jodie Whittaker")
    
    static func loadData() -> [Card] {
        do {
            let data = try Data(contentsOf: Card.savePath)
            let cards = try JSONDecoder().decode([Card].self, from: data)
            return cards
        } catch {
            return []
        }
    }
    
    static func saveData(cards: [Card]) {
        do {
            let data = try JSONEncoder().encode(cards)
            try data.write(to: Card.savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save cards data")
        }
    }
    
}
