//
//  AudioManager.swift
//  League of Monsters
//
//  Created by Aniello Ambrosio on 01/03/22.
//

import Foundation
import SwiftUI
import AVFoundation

class AudioManager: ObservableObject{
    
    @Published var backgroundPlayer: AVAudioPlayer?
    @Published var backgroundAudioFile: String?
    
    func playBackgroundAudio() {
        
        if let audioURL = Bundle.main.url(forResource: backgroundAudioFile, withExtension: "wav") {
            do {
                try self.backgroundPlayer = AVAudioPlayer(contentsOf: audioURL)
                self.backgroundPlayer?.numberOfLoops = 1000000000
                self.backgroundPlayer?.play()
            } catch {
                print("Couldn't play audio. Error: \(error)")
            }
            
        } else {
            print("No audio file found")
        }
        
    }
}

