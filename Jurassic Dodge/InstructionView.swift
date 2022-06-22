//
//  InstructionView.swift
//  Jurassic Dodge
//
//  Created by Giuseppe Falso on 11/05/22.
//

import SwiftUI

struct InstructionView: View {
    @State private var textOpacity = 1.0
    @State private var leftInstructionsOpacity = 0.4
    @State private var rightInstructionsOpacity = 0.0
    @State private var leftDegree = 0.3
    @State private var rightDegree = 0.0
    
    @State var firstInstructions = true
    
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    
    var body: some View {
        Image("background - meteor")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height)
            .frame(minWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height)
            .offset(x: 0, y: (((UIScreen.main.bounds.height) > 413) && UIScreen.main.bounds.width > 736) ? -30 : 0)
            .overlay {
                Color.black
                    .ignoresSafeArea()
                    .opacity(0.5)
                
                if firstInstructions {
                    ZStack {
                        HStack {
                            ZStack {
                                Image("half_screen_white")
                                    .resizable()
                                    .opacity(leftInstructionsOpacity)
                                    .onAppear{
                                        withAnimation{
                                            leftInstructionsOpacity = 0.0
                                        }
                                    }
                                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses:true))
                                
                                Image("hand - right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: leftDegree))
                                    .frame(maxWidth: UIScreen.main.bounds.width/5, maxHeight: UIScreen.main.bounds.height/4)
                                    .onAppear{
                                        withAnimation{
                                            leftDegree = 0.0
                                        }
                                    }
                                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses:true))
                            }
                            ZStack {
                                Image("half_screen_white")
                                    .resizable()
                                    .opacity(rightInstructionsOpacity)
                                    .onAppear{
                                        withAnimation{
                                            rightInstructionsOpacity = 0.4
                                        }
                                    }
                                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses:true))
                                
                                Image("hand - left")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: rightDegree))
                                    .frame(maxWidth: UIScreen.main.bounds.width/5, maxHeight: UIScreen.main.bounds.height/4)
                                    .onAppear{
                                        withAnimation{
                                            rightDegree = 0.3
                                        }
                                    }
                                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses:true))
                                
                            }
                            
                        }
                        .padding()
                        
                        VStack {
                            Text("Move where you tap")
                                .foregroundColor(.white)
                                .font(Font.custom("Minecraft", size: 50.0))
                                .padding(40)
                            
                            Spacer()
                        }
                    }
                } else {
                    ZStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Meteors may drop power ups!")
                                .foregroundColor(.white)
                                .font(Font.custom("Minecraft", size: 50.0))
                            
                            HStack {
                               Image("power-up-heart")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: UIScreen.main.bounds.width/5, maxHeight: UIScreen.main.bounds.height/5)
                                Text("Gain an extra life.")
                                    .foregroundColor(.white)
                                    .font(Font.custom("Minecraft", size: 30.0))
                            }
                            
                            HStack {
                                Image("power-up-armor")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: UIScreen.main.bounds.width/5, maxHeight: UIScreen.main.bounds.height/5)
                                Text("Protect yourself from one hit.")
                                    .foregroundColor(.white)
                                    .font(Font.custom("Minecraft", size: 30.0))

                            }
                            
                            HStack {
                                Image("power-up-mango")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: UIScreen.main.bounds.width/5, maxHeight: UIScreen.main.bounds.height/5)
                                Text("Gain a burst of speed.")
                                    .foregroundColor(.white)
                                    .font(Font.custom("Minecraft", size: 30.0))
                            }
                        }
                        .padding()
                        
                        VStack {
                            Spacer()
                            Text("Tap to play")
                                .foregroundColor(.white)
                                .font(Font.custom("Minecraft", size: 30.0))
                                .opacity(textOpacity)
                                .padding()
                                .onAppear{
                                    withAnimation{
                                        textOpacity = 0.0
                                    }
                                }
                            .animation(Animation.easeInOut(duration:0.5).repeatForever(autoreverses:true))
                        }
                    }
                }
                
            }
            .onTapGesture {
                if !firstInstructions {
                    gameLogic.currentGameState = .playing
                } else {
                    firstInstructions.toggle()
                }
            }
    }
}

struct InstructionView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
