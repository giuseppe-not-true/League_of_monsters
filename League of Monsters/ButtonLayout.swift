//
//  ButtonLayout.swift
//  League of Monsters
//
//  Created by Aniello Ambrosio on 01/03/22.
//

import SwiftUI

struct ButtonLayout : View{
    let label: LocalizedStringKey
    let wid: CGFloat
    var body: some View {
        Trapezoid()
            .frame(width: wid, height: 70, alignment: .center)
            .foregroundColor(Color("Black Menu"))
            .overlay(){
                Text(label)
                    .foregroundColor(.white)
                    .font(Font.custom("Phosphate", size: 40))
                    .padding()
    }
}
}
