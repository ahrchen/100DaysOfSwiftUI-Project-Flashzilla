//
//  Card.swift
//  Flashzilla
//
//  Created by Raymond Chen on 4/13/22.
//

import Foundation

struct Card: Codable, Identifiable{
    let id = UUID()
    let prompt: String
    let answer: String
    
    static let example = Card(prompt: "Who played the 13 Doctor in Doctor Who?", answer: "Jodie Whittaker")
    
//    func removeCard() {
//        
//    }
}
