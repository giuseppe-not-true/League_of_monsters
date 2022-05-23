//
//  MeteorsView.swift
//  League of Monsters
//
//  Created by Giuseppe Falso on 04/03/22.
//

import Foundation
import SwiftUI


struct MeteorsView: View {
    @Binding var pos: CGPoint
    @State var randomDelay1 = 1.0
    @State var randomDelay2 = 2.0
    @State var randomDelay3 = 2.5
    @State var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State var img = String("Custom Preset")
    
    var body: some View {
        ZStack {
            Image(img)
                .frame(width: 50, height: 50)
                .scaleEffect(0.5)
                .opacity(0.2)
                .position(pos)
                .animation(Animation.linear(duration: 4).repeatForever(autoreverses: false).delay(randomDelay1), value: pos)
            
            Image(img)
                .frame(width: 50, height: 50)
                .scaleEffect(0.5)
                .opacity(0.2)
                .position(x: pos.x - 400, y: pos.y)
                .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false).delay(randomDelay2), value: pos)

            Image(img)
                .frame(width: 50, height: 50)
                .scaleEffect(0.5)
                .opacity(0.2)
                .position(x: pos.x + 400, y: pos.y)
                .animation(Animation.linear(duration: 3).repeatForever(autoreverses: false).delay(randomDelay3), value: pos)
        }
        .onReceive(timer) {timer in
            if img == "Custom Preset Copy" {
                img = "Custom Preset"
            } else {
                img = "Custom Preset Copy"
            }
        }
    }
}
