//
//  InstructionView.swift
//  Jurassic Dodge
//
//  Created by Giuseppe Falso on 11/05/22.
//

import SwiftUI

struct InstructionView: View {
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared

    var body: some View {
        Image("background")
            .resizable()
            .ignoresSafeArea()
            .overlay {
                Text("Tap to play")
                    .foregroundColor(.white)
                    .font(Font.custom("Minecraft", size: 25.0))
            }
            .onTapGesture {
                gameLogic.currentGameState = .playing
            }
    }
}

struct InstructionView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
