//
//  PlayerScore.swift
//  League of Monsters
//
//  Created by Giuseppe Falso on 07/03/22.
//

import Foundation
import SwiftUI

class PlayerScore: ObservableObject, Identifiable, Comparable {
    static func < (lhs: PlayerScore, rhs: PlayerScore) -> Bool {
        if lhs.score <= rhs.score {
            return true
        } else {
            return false
        }
    }
    
    static func == (lhs: PlayerScore, rhs: PlayerScore) -> Bool {
        if lhs.score == rhs.score {
            return true
        } else {
            return false
        }
    }
    
    let id = UUID()
    @Published var nickname: String
    @Published var score: Int
    
    init(nickname: String, score: Int) {
        self.nickname = nickname
        self.score = score
    }
}

class ScoreManager: ObservableObject {
    @Published var players = [PlayerScore(nickname: "Lizarro", score: 65), PlayerScore(nickname: "Corgirus", score: 40), PlayerScore(nickname: "Beehemoth", score: 3)]
    
}
