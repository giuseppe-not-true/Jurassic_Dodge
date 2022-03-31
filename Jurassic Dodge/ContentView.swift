//
//  ContentView.swift
//  Jurassic Dodge
//
//  Created by Giuseppe Falso on 30/03/22.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    let scene = GameScene(fileNamed: "GameScene")!
    @State var currentGameState: GameState = .mainScreen
    
    var body: some View {
        
        switch currentGameState {
        case .mainScreen:
            MenuView(currentGameState: $currentGameState)
        case .playing:
            SpriteView(scene: scene)
                .ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewInterfaceOrientation(.landscapeRight)
    }
}
