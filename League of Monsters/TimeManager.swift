//
//  TimeManager.swift
//  League of Monsters
//
//  Created by Aniello Ambrosio on 01/03/22.
//

import SwiftUI

class TimeManager: ObservableObject {
    
    @Published var timeRemaining = 150
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func secondsToMinutes(_ seconds: Int) -> (Int) {
        return ((seconds % 3600) / 60)
    }
    
    func secondsToSeconds(_ seconds: Int) -> (Int) {
        return ((seconds % 3600) % 60)
    }
    
}
