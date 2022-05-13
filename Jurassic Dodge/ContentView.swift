//
//  ContentView.swift
//  Jurassic Dodge
//
//  Created by Giuseppe Falso on 30/03/22.
//

import SwiftUI
import SpriteKit
import AVFoundation

struct ContentView: View {
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    @State var music = AudioPlayer()
    @State var isMuted: Bool = false
    
    var body: some View {
        switch gameLogic.currentGameState {
        case .mainScreen:
            MenuView(isMuted: $isMuted)
                .onAppear {
                    music.stopBackgroundMusic()
                }
        case .instructions:
            InstructionView()
                .onAppear {
                    music.stopBackgroundMusic()
                }
        case .playing:
            GameSceneView(isMuted: $isMuted)
                .onAppear {
                    if !self.isMuted {
                        music.playBackgroundMusic()
                    }
                }
                .onChange(of: gameLogic.isGameOver) { newValue in
                    if !self.isMuted {
                        if newValue {
                            music.stopBackgroundMusic()
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
