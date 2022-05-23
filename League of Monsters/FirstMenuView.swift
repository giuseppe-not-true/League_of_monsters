//
//  FirstMenuView.swift
//  League of Monsters
//
//  Created by Aniello Ambrosio on 01/03/22.
//

import SwiftUI
import AVFoundation


struct FirstMenuView: View {
    @State var dontChangeElevator = true
    @Binding var changeView: Int
    @EnvironmentObject var audiomanager: AudioManager
    @State var pos = CGPoint(x: UIScreen.main.bounds.width, y: -250)

    var body: some View {
        ZStack{
            
            Color("Wine Red")
                .ignoresSafeArea()
            
            MeteorsView(pos: $pos)

            VStack {
                GeometryReader {geometry in
                    VStack (spacing: 20){
                        Text("League of Monsters")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 20)
                            .font(Font.custom("Phosphate", size: 70))
                            .dynamicTypeSize(.large)
                        
                        VStack(alignment: .center, spacing: 25) {
                            
                            Menubutton(dontChangeElevator: $dontChangeElevator, changeView: $changeView, viewcode: 1, name: LocalizedStringKey("Play"))
                            Menubutton(dontChangeElevator: $dontChangeElevator, changeView: $changeView, viewcode: 2, name: LocalizedStringKey("Scorebonk"))
                            Menubutton(dontChangeElevator: $dontChangeElevator, changeView: $changeView, viewcode: 3, name: LocalizedStringKey("Credits"))
                        }
                    }
                    .position(x: geometry.size.width/2, y: geometry.size.height/2)
                }
                .padding()
                .onAppear(){
                    if dontChangeElevator == true {
                        audiomanager.backgroundAudioFile = "MenuMusic"
                        audiomanager.playBackgroundAudio()
                    }
                }
            }
        }
        .onAppear(){
            pos.x -= 1000
            pos.y += 1000
        }
    }
}

func randomDelay() -> Double {
    return Double.random(in: 1...5)
}

func randomPosition() -> CGPoint {
    let pos = CGPoint(x: Double.random(in: 0...UIScreen.main.bounds.width), y: Double.random(in: 0...UIScreen.main.bounds.height))
    return pos
}
