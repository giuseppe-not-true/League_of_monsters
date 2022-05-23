//
//  ProgressBar.swift
//  League of Monsters
//
//  Created by alessandro on 06/03/22.
//

import SwiftUI


struct ProgressBar: View {
    @Binding var value: Double
    @Binding var healthColor: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10).frame(width: geometry.size.width + 4 , height: geometry.size.height + 4)
                    .foregroundColor(Color(UIColor.systemGray))
                    .overlay(){
                        RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 4)
                    }
                    .opacity(0.3)

                
                RoundedRectangle(cornerRadius: 10).frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(healthColor)
                    .animation(.linear, value: value)
                    .offset(x: 2)
            }
        }
    }
}
