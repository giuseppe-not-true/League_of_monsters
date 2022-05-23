//
//  Menubutton.swift
//  League of Monsters
//
//  Created by Aniello Ambrosio on 01/03/22.
//

import SwiftUI

struct Menubutton: View {
    @Binding var dontChangeElevator: Bool
    @Binding var changeView: Int
    let viewcode: Int
    let name: LocalizedStringKey
    var body: some View {
        Button {
            dontChangeElevator = false
            changeView = viewcode
        } label: {
            ButtonLayout(label: name,wid: 350)
                .dynamicTypeSize(.large)
        }
    }
}


