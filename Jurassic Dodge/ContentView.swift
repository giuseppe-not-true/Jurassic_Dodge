//
//  ContentView.swift
//  Jurassic Dodge
//
//  Created by Giuseppe Falso on 30/03/22.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    
    var body: some View {
        switch gameLogic.currentGameState {
        case .mainScreen:
            MenuView()
        case .playing:
            SpriteView(scene: GameScene())
                .ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewInterfaceOrientation(.landscapeRight)
    }
}
