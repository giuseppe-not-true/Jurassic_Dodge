//
//  ContentView.swift
//  Jurassic Dodge
//
//  Created by Giuseppe Falso on 30/03/22.
//

import SwiftUI
import SpriteKit
import GameKit
import AVFoundation

struct ContentView: View {
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    @State var music = AudioPlayer()
    @State var isMuted: Bool = false
    @State var isFeedbackMuted: Bool = false
    let localPlayer = GKLocalPlayer.local
    
    func authenticateUser() {
        localPlayer.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            GKAccessPoint.shared.isActive = localPlayer.isAuthenticated
        }
    }
    
    init() {
        GKAccessPoint.shared.location = .topLeading
        GKAccessPoint.shared.showHighlights = true
        GKAccessPoint.shared.isActive = true
        
        if GKLocalPlayer.local.isAuthenticated {
            GKLeaderboard.submitScore(
                UserDefaults.standard.integer(forKey: "HighScore"),
                context: 0,
                player: GKLocalPlayer.local,
                leaderboardIDs: ["Jurassic_Dodge_Highscores"]
            ) { error in
                print(error)
            }
    }
    
    var body: some View {
        switch gameLogic.currentGameState {
        case .mainScreen:
            MenuView(isMuted: $isMuted, isFeedbackMuted: $isFeedbackMuted)
                .onAppear {
                    authenticateUser()
                    music.stopBackgroundMusic()
                    
                    withAnimation {
                        GKAccessPoint.shared.isActive = true
                    }
                    
                    if GKLocalPlayer.local.isAuthenticated {
                        GKLeaderboard.submitScore(
                            UserDefaults.standard.integer(forKey: "HighScore"),
                            context: 0,
                            player: GKLocalPlayer.local,
                            leaderboardIDs: ["Jurassic_Dodge_Highscores"]
                        ) { error in
                            print(error)
                        }
                    }
                }
        case .instructions:
            InstructionView()
                .onAppear {
                    music.stopBackgroundMusic()
                    
                    withAnimation {
                        GKAccessPoint.shared.isActive = false
                    }
                }
        case .playing:
            GameSceneView(music: $music, isMuted: $isMuted, isFeedbackMuted: $isFeedbackMuted)
                .onAppear {
                    if !self.isMuted {
                        music.playBackgroundMusic()
                    }
                    
                    withAnimation {
                        GKAccessPoint.shared.isActive = false
                    }
                }
                .onChange(of: gameLogic.isGameOver) { newValue in
                    if !self.isMuted {
                        if newValue {
                            music.stopBackgroundMusic()
                            music.resetBackgroundMusic()
                        } else {
                            music.playBackgroundMusic()
                        }
                    }
                }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().previewInterfaceOrientation(.landscapeRight)
//    }
//}
