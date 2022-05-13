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
    @State var highScore = 0
    @Binding var isMuted: Bool
    @Binding var isFeedbackMuted: Bool
        
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
                    
                    Text("Highscore: \(String(UserDefaults.standard.integer(forKey: "HighScore")))")
                        .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height*0.15)
                        .foregroundColor(.white)
                        .font(Font.custom("Minecraft", size: 25.0))
                    
                    HStack {
                        Button("Mute") {
                            isMuted.toggle()
                        }
                        
                        Button("Haptic Feedback") {
                            isFeedbackMuted.toggle()
                        }
                    }


                }
            }
        }
        .onTapGesture {
            gameLogic.currentGameState = .instructions
        }
    }
}
