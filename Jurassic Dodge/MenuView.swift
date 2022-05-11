//
//  MenuView.swift
//  Jurassic Dodge
//
//  Created by Giuseppe Falso on 01/04/22.
//

import Foundation
import SwiftUI

struct MenuView: View {
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    
    var body: some View {
        ZStack{
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            Image("dino-front")
                .resizable()
                .frame(width: 100.0, height: 100.0)
                .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height * 0.85)
        }
        .overlay {
            Color.black
                .ignoresSafeArea()
                .opacity(0.5)
            
            VStack() {
                VStack {
                    VStack(spacing: 0) {
                        Image("JURASSIC")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/3)
                            .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/6)
                        
                        Image("DODGE")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/6)
                            .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/6)
                    }
                    .padding()
                    
                    Text(LocalizedStringKey("Tap the sides of the screen to move left and right."))
                        .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height*0.1)
                        .foregroundColor(.white)

                }
            }
        }.onTapGesture {
            gameLogic.currentGameState = .playing
        }
    }
}
