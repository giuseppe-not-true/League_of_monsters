//
//  ContentView.swift
//  League of Monsters
//
//  Created by Aniello Ambrosio on 01/03/22.
//

import SwiftUI
import AVFoundation


struct ContentView: View {
    @State var switcherView = 0
    @StateObject var audiomanager = AudioManager()
    @StateObject var scoreManager = ScoreManager()
    var body: some View {
        //Controller che seleziona la scena da mostrare
        switch switcherView{
            //Case 0 è il caso di default di avvio gioco
        case 0:
            FirstMenuView(changeView: self.$switcherView/*, audiomanager: self.$audiomanager*/).environmentObject(audiomanager)
        case 1:
            GameView(changeView: self.$switcherView/*, audiomanager: self.$audiomanager*/).environmentObject(audiomanager)
                .environmentObject(scoreManager)
        case 2:
            ScoreboardView(changeView: self.$switcherView)
                .environmentObject(scoreManager)
            
        case 3:
            CreditsView(changeView: self.$switcherView)
        default:
            FirstMenuView(changeView: self.$switcherView/*, audiomanager: self.$audiomanager*/).environmentObject(audiomanager)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
