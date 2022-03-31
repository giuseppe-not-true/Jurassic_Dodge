//
//  MenuView.swift
//  Jurassic Dodge
//
//  Created by Giuseppe Falso on 01/04/22.
//

import Foundation
import SwiftUI

struct MenuView: View {
    @Binding var currentGameState: GameState
    
    var body: some View {
        ZStack{
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            Image("dino-front")
                .resizable()
                .frame(width: 100.0, height: 100.0)
                .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height * 0.8)
        }
        .overlay {
            Color.black
                .ignoresSafeArea()
                .opacity(0.5)
            
            VStack() {
                Text("Jurassic Dodge")
                    .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height*0.2)
                    .foregroundColor(.white)
                    .font(.largeTitle)
                Text("Tap to save Roger from extinction!")
                    .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height*0.1)
                    .foregroundColor(.white)
            }
        }.onTapGesture {
            currentGameState = .playing
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(currentGameState: .constant(.mainScreen)).previewInterfaceOrientation(.landscapeRight)
    }
}
