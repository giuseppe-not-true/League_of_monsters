//
//  SelectionView.swift
//  League of Monsters
//
//  Created by Aniello Ambrosio on 01/03/22.
//

import SwiftUI
import SpriteKit
import AVFoundation

struct GameView: View {
    @State private var scene: GameScene? = GameScene(fileNamed: "GameScene")
    @Binding var changeView: Int
    @EnvironmentObject var audiomanager: AudioManager
//    @EnvironmentObject var playerScore: PlayerScore
    @State var isToAppend = false
    @State var playerScore = PlayerScore(nickname: "Dogezilla", score: 0)
    @EnvironmentObject var scoreManager: ScoreManager
    @StateObject var timemanager = TimeManager()
    @State var selectionview = SelectionViewModel()
    //Bool
    @State var isPlaying = false
    @State var isZoomedOut = false
    @State var gameOver = false
    @State var isInPauseMenu = false
    @State var disableBonk = false
    @State var isTappable = true
    //
    @State var m = 0
    @State var s = 0
    @State private var scrollCitySelection = 0
    @State var monsterSelection = 0
    @State var pauseButton = "pause.circle"
    @Environment(\.scenePhase) var scenePhase
    
    @State var playerHealth: Double = 1.0
    @State var healthColor = Color.green

    
    var body: some View {
        
        if self.isPlaying {
            ZStack {
                GeometryReader { geometry in
                    SpriteView(scene: scene!, options: .allowsTransparency)
                        .ignoresSafeArea()
                        .onAppear(){
                            self.scene?.scaleMode = .aspectFill
                            self.scene?.childNode(withName: "transenne")?.physicsBody = SKPhysicsBody(edgeLoopFrom: self.scene!.childNode(withName: "transenne")!.frame)
                            self.scene?.analogJoystick.position.x = -300
                            self.scene?.analogJoystick.position.y = -110
                            
                        }
                        .onChange(of: scenePhase) { newPhase in
                            if newPhase == .active {
                                print("Active")
                                if pauseButton == "play.circle" {
                                    self.scene?.analogJoystick.resetStick()
                                    disableBonk=true
                                    scene?.view?.isPaused=true
                                    isTappable=true
                                } else {
                                    timemanager.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                                }
                            } else if newPhase == .inactive {
                                print("Inactive")
                                if pauseButton == "play.circle" {
                                    self.scene?.analogJoystick.resetStick()
                                    disableBonk=true
                                    scene?.view?.isPaused=true
                                    isTappable=false
                                } else {
                                    timemanager.timer.upstream.connect().cancel()
                                }
                            } else if newPhase == .background {
                                if pauseButton == "play.circle" {
                                    self.scene?.analogJoystick.resetStick()
                                    disableBonk=true
                                    scene?.view?.isPaused=true
                                    isTappable=false
                                } else {
                                    timemanager.timer.upstream.connect().cancel()
                                }
                                print("Background")
                            }
                        }
                }
                
                GeometryReader { geometry in
                    
                    ProgressBar(value: $playerHealth, healthColor: $healthColor)
                        .frame(width: geometry.size.width * 0.45 , height: geometry.size.height/10)
                        .position(x: geometry.size.width/2, y: geometry.size.height*0.9)
                        .opacity(0.8)
                        .onChange(of: playerHealth){ newFloat in
                            if playerHealth >= 0.0 && playerHealth <= 0.3 {
                                healthColor = Color.red
                            } else if playerHealth > 0.3 && playerHealth <= 0.6 {
                                healthColor = Color.yellow
                            } else {
                                healthColor = Color.green
                            }
                        }
                    
                    Button {
                        if self.scene?.left==true{
                            self.scene?.player.bonkLeft()
                        }
                        else{
                            self.scene?.player.bonkRight()
                        }
                        if !disableBonk{
                            let seconds = 0.4
                            DispatchQueue.main.asyncAfter(deadline: .now() + seconds){
                                if !(scene?.targetToDestroy.isEmpty ?? false) {
                                    scene?.changeTexture(scene?.targetToDestroy[(scene?.targetToDestroy.count ?? 0 )-1] as! SKSpriteNode)
                                    
                                    //AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                                    let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                                        impactMed.impactOccurred()
                                }
                            }
                        }
                    } label: {
                        Image("bonk")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                        
                    }
                    .disabled(disableBonk)
                .position(x: (UIScreen.main.bounds.width * 0.83), y: (UIScreen.main.bounds.height * 0.79))
                }
                
                
                GeometryReader { geometry in
                    HStack (spacing: 0){
                        HStack {
                            Text(LocalizedStringKey("Score: "))
                                .font(Font.custom("Phosphate", size: 35))
                                .foregroundColor(.white)
                            Text("\(self.scene?.score ?? 0)")
                                .font(Font.custom("Phosphate", size: 35))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Rectangle()
                            .foregroundColor(.clear)
                            .overlay(){
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(Color("Wine Red"))
                                    .frame(width: 150, height: 100, alignment: .center)
                                    .overlay(){
                                        Text(String(format: "%02d:%02d", m, s))
                                            .foregroundColor(.white)
                                            .font(Font.custom("Phosphate", size: 45))
                                            .offset(x: 0, y: 10)
                                    }
                            }
                            .frame(width: 280, height: 80, alignment: .center)
                            .padding(.bottom, 40)
                        
                        Button {
                            if isTappable{
                                isTappable = false
                                self.scene?.analogJoystick.isUserInteractionEnabled = false
                                //Da play a pausa
                                if pauseButton == "pause.circle" {
                                    
                                    self.scene?.analogJoystick.resetStick()
                                    disableBonk=true
                                    
                                    
                                    if !isZoomedOut{
                                        self.scene?.analogJoystick.resetStick()
                                        
                                        isZoomedOut=true
                                        let zoomOutAction = SKAction.scale(to: 2.5, duration: 0.5)
                                        self.scene?.camera!.run(zoomOutAction)
                                        
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                                        timemanager.timer.upstream.connect().cancel()
                                        scene?.view?.isPaused=true
                                        pauseButton = "play.circle"
                                        isTappable = true
                                        
                                    }
                                    
                                }
                                
                                else if pauseButton == "play.circle"{
                                    
                                    self.scene?.analogJoystick.resetStick()
                                    disableBonk=false
                                    
                                    if isZoomedOut{
                                        self.scene?.analogJoystick.resetStick()
                                        isZoomedOut=false
                                        pauseButton = "pause.circle"
                                        scene?.view?.isPaused=false
                                        self.scene?.camera!.run(SKAction.scale(to: 1.0, duration: 0.5))
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                                        timemanager.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                                        isTappable = true
                                        self.scene?.analogJoystick.isUserInteractionEnabled = true
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: pauseButton)
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                                .frame(width: 250, alignment: .trailing)
                        }
                        .allowsHitTesting(isTappable)
                        
                        
                    }
                    .position(x: (geometry.size.width * 0.5), y: (geometry.size.height * 0.11))
                    //Da pausa a play
                    if pauseButton != "pause.circle" {
                        GeometryReader { geometry in
                            VStack (spacing: 40){
                                Button(action: {
                                    timemanager.timeRemaining = 150
                                    audiomanager.backgroundPlayer?.stop()
                                    self.isPlaying.toggle()
                                    pauseButton = "pause.circle"
                                    isZoomedOut=false
                                    audiomanager.backgroundAudioFile = "MenuMusic"
                                    audiomanager.playBackgroundAudio()
                                }, label: {
                                    ButtonLayout(label: "Run Away",wid:280)
                                })
                                Button(action: {
                                    timemanager.timeRemaining = 150
                                    self.scene = GameScene(fileNamed: "GameScene")
                                    self.isPlaying = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                        self.isPlaying = true
                                    }
                                    pauseButton = "pause.circle"
                                    isZoomedOut=false
                                    audiomanager.backgroundAudioFile = "Soundtrack"
                                    audiomanager.playBackgroundAudio()
                                    disableBonk = false
                                }, label: {
                                    ButtonLayout(label: "Rampage",wid:280)
                                    
                                })
                                
                            }
                            .position(x: geometry.size.width / 2, y: geometry.size.height/1.8)
                            
                        }
                    }
                    
                    if gameOver == true{
                        GeometryReader{ geometry in
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.black)
                                    .ignoresSafeArea()
                                    .frame(width: geometry.size.width * 1, height: geometry.size.height * 1)
                                    .position(x: geometry.size.width/2, y: geometry.size.height/2)
                                    .opacity(0.4)
                                
                                Trapezoid()
                                    .ignoresSafeArea()
                                    .foregroundColor(Color("Wine Red"))
                                    .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.70)
                                    .position(x: geometry.size.width/2, y: geometry.size.height/2)
                                    .overlay(){
                                        VStack (spacing: 30){
                                            Text(LocalizedStringKey("GAME OVER"))
                                                .foregroundColor(.white)
                                                .font(Font.custom("Phosphate", size: 70))
                                            HStack (spacing: 40){
                                                Button(action: {
                                                    audiomanager.backgroundPlayer?.stop()
                                                    self.isPlaying.toggle()
                                                    timemanager.timeRemaining = 150
                                                    self.gameOver = false
                                                    isTappable = true
                                                    audiomanager.backgroundAudioFile = "MenuMusic"
                                                    audiomanager.playBackgroundAudio()
                                                }, label: {
                                                    ButtonLayout(label: "Run Away",wid:280)
                                                })
                                                
                                                
                                                Button(action: {
                                                    
                                                   
                                                    self.isPlaying = false
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                                        
                                                        self.isPlaying = true
                                                        self.gameOver = false
                                                        timemanager.timeRemaining = 150
                                                        timemanager.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                                                        self.scene = GameScene(fileNamed: "GameScene")
                                                        isZoomedOut=false
                                                        audiomanager.backgroundAudioFile = "Soundtrack"
                                                        audiomanager.playBackgroundAudio()
                                                        disableBonk = false
                                                        isTappable = true
                    
                                                    }

                                                    
                                                }, label: {
                                                    ButtonLayout(label: "Rampage",wid:280)
                                                })
                                            }
                                        }
                                    }
                                    .onChange(of: scenePhase) { newPhase in
                                        
                                        if newPhase == .active {
                                            print("Active")
                                            timemanager.timeRemaining += 1
                                            scene?.view?.isPaused=true
                                            self.scene?.analogJoystick.resetStick()
                                            disableBonk=true
                                            isTappable=true
                                            
                                        } else if newPhase == .inactive {
                                            
                                            print("Inactive")

                                        } else if newPhase == .background {
                                            
                                            self.scene?.analogJoystick.resetStick()
                                            disableBonk=true
                                            scene?.view?.isPaused=true
                                            isTappable=false
                                            
                                            print("Background")
                                        }
                                    }
                                
                                
                            }
                            .onAppear(){

                                self.scene?.isPaused.toggle()
                                timemanager.timer.upstream.connect().cancel()
                                isTappable = false
                                playerScore.score = self.scene!.score
                                
                                for i in scoreManager.players {
                                    if i.nickname == "Dogezilla" {
                                        if playerScore.score >= i.score {
                                            i.score = playerScore.score
                                            isToAppend = false
                                            break
                                        }
                                    } else {
                                        isToAppend = true
                                    }
                                }
                                
                                if isToAppend {
                                    scoreManager.players.append(playerScore)
                                    isToAppend = false
                                }
                            }
                        }
                        
                        
                    }
                    
                }
                .onReceive(timemanager.timer) { time in
                    if timemanager.timeRemaining > 0 {
                        timemanager.timeRemaining -= 1
                        m = timemanager.secondsToMinutes(timemanager.timeRemaining)
                        s = timemanager.secondsToSeconds(timemanager.timeRemaining)
                        
                        playerHealth = (self.scene!.player.health)/100
                        if playerHealth <= 0.0 {
                            self.gameOver = true
                            timemanager.timer.upstream.connect().cancel()
                        }
                    } else {
                        self.gameOver = true
                        self.scene?.analogJoystick.resetStick()
                        scene?.view?.isPaused.toggle()
                        timemanager.timer.upstream.connect().cancel()
                        
                    }
                }
            }
            
        }
        else if !self.isPlaying {
            ZStack {
                VStack(spacing: 90) {
                    GeometryReader { geometry in
                        HStack {
                            
                            VStack(spacing: 10) {
                                Text(selectionview.monstersName[monsterSelection])
                                    .font(Font.custom("Phosphate", size: 18))
                                    .dynamicTypeSize(.accessibility3)
                                    .foregroundColor(.white)
                                    .frame(width: geometry.size.width/3, height: geometry.size.height/6, alignment: .center)
                                    .padding()
                                
                                LazyVGrid(columns: selectionview.columns, alignment: .center, spacing: 40)
                                {
                                    ForEach(0..<selectionview.monsters.count){ item in
                                        if item >= 1 && item <= selectionview.monsters.count {
                                            Button (action: {
                                                monsterSelection = item
                                            }) {
                                                selectionview.monsters[item]
                                                    .resizable()
                                                    .colorMultiply(.gray)
                                                    .frame(width: geometry.size.width/10, height: geometry.size.width/10)
                                            }
                                            .disabled(true)
                                        } else {
                                            Button (action: {
                                                monsterSelection = item
                                            }) {
                                                selectionview.monsters[item]
                                                    .resizable()
                                                    .frame(width: geometry.size.width/10, height: geometry.size.width/10)
                                            }
                                            .shadow(color: monsterSelection == item ? .yellow : Color(.black).opacity(0.2), radius: 0, x: 5, y: 5)
                                        }
                                    }
                                }
                                .frame(width: geometry.size.width/3, height: geometry.size.height/1.1, alignment: .center)
                                .padding()
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 15){
                                Text(LocalizedStringKey("Stage:"))
                                    .font(Font.custom("Phosphate", size: 20))
                                    .dynamicTypeSize(.accessibility3)
                                    .foregroundColor(.white)
                                    .frame(width: geometry.size.width/3, height: geometry.size.height/6, alignment: .center)
                                    .padding()
                                
                                ScrollViewReader { scroll in
                                    VStack(spacing: 5) {
                                        Button(action: {
                                            withAnimation {
                                                if scrollCitySelection > 0 {
                                                    scrollCitySelection -= 1
                                                    scroll.scrollTo(scrollCitySelection, anchor: .center)
                                                }
                                            }
                                        }) {
                                            if scrollCitySelection == 0 {
                                                Image(systemName: "arrowtriangle.up.fill")
                                                    .scaledToFill()
                                                    .frame(width: UIScreen.main.bounds.width/10, height: 20)
                                                    .foregroundColor(Color.gray)
                                                    .disabled(true)
                                                    .shadow(color: Color(.black).opacity(0.5), radius: 2, x: 2, y: 2)
                                            } else if scrollCitySelection > 0 {
                                                Image(systemName: "arrowtriangle.up.fill")
                                                    .scaledToFill()
                                                    .frame(width: UIScreen.main.bounds.width/10, height: 20)
                                                    .shadow(color: Color(.black).opacity(0.5), radius: 2, x: 2, y: 2)
                                            }
                                        }
                                        .foregroundColor(Color("Sand"))
                                        
                                        ScrollView(.vertical, showsIndicators: false) {
                                            LazyVStack(spacing: 30) {
                                                ForEach(0..<3, id: \.self) {item in
                                                    Image("Stage Trapezoid")
                                                        .resizable()
                                                        .frame(width: geometry.size.width/2.5, height: geometry.size.height/1.3, alignment: .center)
                                                        .overlay {
                                                            Text(LocalizedStringKey(selectionview.cities[item]))
                                                                .font(Font.custom("Phosphate", size: 15))
                                                                .dynamicTypeSize(.accessibility2)
                                                                .foregroundColor(.white)
                                                            
                                                            if (item <= 3 && item >= 1) {
                                                                Text(LocalizedStringKey("Coming Soon"))
                                                                    .font(Font.custom("Phosphate", size: 12))
                                                                    .dynamicTypeSize(.accessibility2)
                                                                    .foregroundColor(.white)
                                                                    .padding()
                                                                    .frame(height: 40)
                                                                    .background(Trapezoid().foregroundColor(.red))
                                                                    .position(x: geometry.size.width/3.96, y: geometry.size.height/1.75)
                                                                    .dynamicTypeSize(.medium)
                                                            }
                                                        }
                                                    
                                                }
                                            }
                                        }
                                        //                                .disabled(true)
                                        
                                        Button(action: {
                                            withAnimation {
                                                if scrollCitySelection < selectionview.cities.count - 1 {
                                                    scrollCitySelection += 1
                                                    scroll.scrollTo(scrollCitySelection, anchor: .center)
                                                }
                                            }
                                        }) {
                                            if scrollCitySelection == selectionview.cities.count - 1 {
                                                Image(systemName: "arrowtriangle.down.fill")
                                                    .scaledToFill()
                                                    .frame(width: UIScreen.main.bounds.width/10, height: 20)
                                                    .foregroundColor(Color.gray)
                                                    .disabled(true)
                                                    .shadow(color: Color(.black).opacity(0.5), radius: 2, x: 2, y: 2)
                                            } else if scrollCitySelection < selectionview.cities.count - 1 {
                                                Image(systemName: "arrowtriangle.down.fill")
                                                    .scaledToFill()
                                                    .frame(width: UIScreen.main.bounds.width/10, height: 20)
                                                    .shadow(color: Color(.black).opacity(0.5), radius: 2, x: 2, y: 2)
                                            }

                                        }
                                        .foregroundColor(Color("Sand"))
                                        
                                    }
                                    .frame(width: geometry.size.width/2, height: geometry.size.height)
                                }
                                
                            }
                            .padding()
                        }
                    }
                    .padding()
                    
                    
                    Button {
                        if monsterSelection == 0 && scrollCitySelection == 0 {
                            audiomanager.backgroundPlayer?.stop()
                            timemanager.timeRemaining = 150
                            self.scene = GameScene(fileNamed: "GameScene")
                            self.isPlaying.toggle()
                            audiomanager.backgroundAudioFile = "Soundtrack"
                            audiomanager.playBackgroundAudio()
                            isTappable = true
                            disableBonk = false
                        }
                    } label: {
                        ButtonLayout(label: "Rampage",wid:280)
                            .dynamicTypeSize(.large)
                    }
                    

                    
                    
                }
                .background(Color("Wine Red"))
                Image(systemName: "chevron.left.square.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .position(x: UIScreen.main.bounds.width * 0.005, y: UIScreen.main.bounds.height * 0.10)
                    .onTapGesture{
                        changeView = 0
                    }
            }
            
            
        }
    }
    
    
}
