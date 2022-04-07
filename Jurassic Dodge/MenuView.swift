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
            currentGameState = .playing
        }
    }
}

//extension Color {
//    static let greenMenu = UIColor(named: "Green Menu")
//    static let orangeMenu = UIColor(named: "Orange Menu")
//}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(currentGameState: .constant(.mainScreen)).previewInterfaceOrientation(.landscapeRight)
    }
}
