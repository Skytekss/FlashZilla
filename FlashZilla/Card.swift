//
//  Card.swift
//  FlashZilla
//
//  Created by Илья Гринько on 29.11.2024.
//

import Foundation


struct Card: Codable {
  var prompt: String
  var answer: String
  
  static let example = Card(prompt: "Who's the best rapper alive?", answer: "Kanye West")
}
