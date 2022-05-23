//
//  Scoreboard.swift
//  Open Map Test
//
//  Created by Giuseppe Falso on 18/02/22.
//

import SwiftUI

struct scoreRow: View {
    var player: PlayerScore
    
    var body: some View {
        HStack {
            Text(player.nickname)
                .font(Font.custom("Phosphate", size: 20))
            Spacer()
            Text("\(player.score)")
                .font(Font.custom("Phosphate", size: 20))
            
        }
    }
}

struct ScoreboardView: View {
    @Binding var changeView: Int
    @StateObject var yourPlayer = PlayerScore(nickname: "Dogezilla", score: 0)
    
    @EnvironmentObject var scoreManager: ScoreManager
    
    var body: some View {
        ZStack {
            VStack {
                Text(LocalizedStringKey("Scorebonk"))
                    .font(Font.custom("Phosphate", size: 40))
                    .frame(alignment: .center)
                    .padding()
                
                List(scoreManager.players.sorted(by: >)) {score in
                    scoreRow(player: score)
                }
                .frame(alignment: .center)
                .listStyle(.inset)
            }
            .padding()
            
            Image(systemName: "chevron.left.square.fill")
                .font(.largeTitle)
                .position(x: UIScreen.main.bounds.width * 0.05, y: UIScreen.main.bounds.height * 0.15)
                .onTapGesture{
                    changeView = 0
                }
        }
        .onAppear(){
            UITableView.appearance().separatorStyle = .none
            UITableView.appearance().separatorColor = .white
            UITableViewCell.appearance().backgroundColor = UIColor(Color("Wine Red"))
            UITableView.appearance().backgroundColor = UIColor(Color("Wine Red"))
            
        }
        .foregroundColor(.white)
        .background(Color("Wine Red"))
    }
}

struct ScoreboardView_Preview: PreviewProvider {
    static var previews: some View {
        ScoreboardView(changeView: .constant(2)).previewInterfaceOrientation(.landscapeLeft)
    }
}
