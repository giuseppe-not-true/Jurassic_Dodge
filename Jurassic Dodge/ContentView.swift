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
    @ObservedObject var gameCenter: GameCenterController = GameCenterController.shared
    @State var music = AudioPlayer()
    @State var isMuted: Bool = false
    @State var isFeedbackMuted: Bool = false
    
    init() {
        gameCenter.submitScore()
    }
    
    var body: some View {
        switch gameLogic.currentGameState {
        case .mainScreen:
            MenuView(isMuted: $isMuted, isFeedbackMuted: $isFeedbackMuted)
                .onAppear {
                    gameCenter.authenticateUser()
                    music.stopBackgroundMusic()
                    
                    withAnimation {
                        gameCenter.accessPoint.isActive = true
                    }
                    
                    gameCenter.submitScore()
                }
        case .instructions:
            InstructionView()
                .onAppear {
                    music.stopBackgroundMusic()
                    
                    withAnimation {
                        gameCenter.accessPoint.isActive = false
                    }
                }
        case .playing:
            GameSceneView(music: $music, isMuted: $isMuted, isFeedbackMuted: $isFeedbackMuted)
                .onAppear {
                    if !self.isMuted {
                        music.playBackgroundMusic()
                    }
                    
                    withAnimation {
                        gameCenter.accessPoint.isActive = false
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
