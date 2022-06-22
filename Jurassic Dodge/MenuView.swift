//
//  MenuView.swift
//  Jurassic Dodge
//
//  Created by Giuseppe Falso on 01/04/22.
//

import Foundation
import SwiftUI

struct MenuView: View {
    @State private var textOpacity = 1.0
    
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    @State var highScore = 0
    @Binding var isMuted: Bool
    @Binding var isFeedbackMuted: Bool
    
    var body: some View {
        ZStack{
            Image("background - meteor")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height)
                .offset(x: 0, y: (((UIScreen.main.bounds.height) > 413) && UIScreen.main.bounds.width > 736) ? -30 : 0)
                .overlay {
                    Color.black
                        .ignoresSafeArea()
                        .opacity(0.5)
                }
            
            VStack() {
                VStack {
                    VStack(spacing: 0) {
                        Image("JURASSIC")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/3)
                        //                            .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/6)
                        
                        Image("DODGE")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/6)
                        //                            .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/6)
                    }
                    .padding()
                    
                    VStack {
                        Text("Highscore: \(String(UserDefaults.standard.integer(forKey: "HighScore")))")
                            .foregroundColor(.white)
                            .font(Font.custom("Minecraft", size: 25.0))
                        
                        Text("Tap to play")
                            .foregroundColor(.white)
                            .font(Font.custom("Minecraft", size: 25.0))
                            .padding()
                            .opacity(textOpacity)
                            .onAppear{
                                withAnimation{
                                    textOpacity = 0.0
                                }
                            }
                            .animation(Animation.easeInOut(duration:0.5).repeatForever(autoreverses:true))
                    }
                    .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height*0.15)

                    HStack {
                        Button {
                            isMuted.toggle()
                        } label: {
                            if !isMuted {
                                Image("audio_speaker")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            } else {
                                Image("audio_mute")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                        }
                        
                        Button {
                            isFeedbackMuted.toggle()
                        } label: {
                            if !isFeedbackMuted {
                                Image("audio_haptic")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            } else {
                                Image("audio_haptic_mute")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
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
