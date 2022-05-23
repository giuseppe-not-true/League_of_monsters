//
//  Credits.swift
//  Open Map Test
//
//  Created by Giuseppe Falso on 18/02/22.
//

import SwiftUI

struct CreditsView: View {
    @Binding var changeView: Int
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .center,spacing: 30) {
                    VStack(spacing: 0) {
                        Text("Game Design")
                            .font(Font.custom("Phosphate", size: 30))
                        
                        Text("Alessandro Colantonio")
                            .font(.body)
                            .frame(height: UIScreen.main.bounds.height/8, alignment: .leading)
                    }
                    
                    VStack(spacing: 0) {
                        Text(LocalizedStringKey("Code"))
                            .font(Font.custom("Phosphate", size: 30))
                            .frame(alignment: .center)
                        Text ("Alessandro Cei\nAniello Ambrosio\nGiuseppe Falso")
                            .font(.body)
                            .frame(height: UIScreen.main.bounds.height/4, alignment: .leading)
                    }
                    
                    VStack(spacing: 0) {
                        Text(LocalizedStringKey("Art"))
                            .font(Font.custom("Phosphate", size: 30))
                            .frame(alignment: .center)
                        Text("Alessandro Cei - Concept Art\n Giuseppe Falso - UI/UX")
                            .font(.body)
                            .frame(height: UIScreen.main.bounds.height/5, alignment: .leading)
                        Text(LocalizedStringKey("Contributions"))
                            .font(Font.custom("Phosphate", size: 15))
                            .frame(alignment: .center)
                        Text(LocalizedStringKey("GuttyKreum - Clean City tiles\nWesley FG - Marnian Region Tileset\nSalvatore Luca Vessillo - Dogezilla Pixel Art"))
                            .font(.body)
                            .frame(height: UIScreen.main.bounds.height/4, alignment: .leading)
                    }
                    
                    VStack(spacing: 0) {
                        Text(LocalizedStringKey("Animations"))
                            .font(Font.custom("Phosphate", size: 30))
                            .frame(alignment: .center)
                        Text(LocalizedStringKey("Alessandro Colantonio - Character animations\nGiuseppe Falso - Particles FX"))
                            .font(.body)
                            .frame(height: UIScreen.main.bounds.height/5, alignment: .leading)
                    }
                    VStack(spacing: 0) {
                        Text(LocalizedStringKey("Music and Sound Design"))
                            .font(Font.custom("Phosphate", size: 30))
                            .frame(alignment: .center)
                        Text("Alessandro Colantonio")
                            .font(.body)
                            .frame(height: UIScreen.main.bounds.height/6, alignment: .leading)
                        Text(LocalizedStringKey("Soundtracks"))
                            .font(Font.custom("Phosphate", size: 15))
                            .frame(alignment: .center)
                        Text("- Destruição de Ipanema\n- JamiroGUAI")
                            .font(.body)
                            .frame(height: UIScreen.main.bounds.height/6, alignment: .leading)
                        Text(LocalizedStringKey("Contributions"))
                            .font(Font.custom("Phosphate", size: 15))
                            .frame(alignment: .center)
                            .padding(.top, 10)
                        Text("Pro Sound Collection v1.3 - GameMaster Audio")
                            .font(.body)
                            .frame(height: UIScreen.main.bounds.height/8, alignment: .leading)
                    }
                    
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding(.vertical)
            }
            .background(Color("Wine Red"))
            .foregroundColor(.white
            )
            
            Image(systemName: "chevron.left.square.fill")
                .font(.largeTitle)
                .foregroundColor(.white)
                .position(x: UIScreen.main.bounds.width * 0.05, y: UIScreen.main.bounds.height * 0.15)
                .onTapGesture{
                    changeView = 0
                }
        }
    }
}

struct CreditsView_Preview: PreviewProvider {
    static var previews: some View {
        CreditsView(changeView: .constant(3)).previewInterfaceOrientation(.landscapeLeft)
    }
}
