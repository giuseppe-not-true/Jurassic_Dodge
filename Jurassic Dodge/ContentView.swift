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
    
    var body: some View {
        switch gameLogic.currentGameState {
        case .mainScreen:
            MenuView()
                .onAppear {
                    music.stopBackgroundMusic()
                }
        case .instructions:
            InstructionView()
                .onAppear {
                    music.stopBackgroundMusic()
                }
        case .playing:
            GameSceneView()
                .onAppear {
                    music.playBackgroundMusic()
                }
                .onChange(of: gameLogic.isGameOver) { newValue in
                    if newValue {
                        music.stopBackgroundMusic()
                    } else {
                        music.playBackgroundMusic()
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
