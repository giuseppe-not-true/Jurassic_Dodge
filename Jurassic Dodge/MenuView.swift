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
                VStack(spacing: 0) {
                    Text("JURASSIC")
                        .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height*0.2)
                        .font(Font.custom("Hawai", size: 70))
                        .foregroundColor(.white)

                    Text("DODGE")
                        .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height*0.12)
                        .font(Font.custom("Speedway", size: 55))
                        .foregroundColor(.white)
//                        .foregroundColor(UIColor.orangeMenu)

                }

                    
                Text("Tap to save Roger from extinction!")
                    .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height*0.1)
                    .foregroundColor(.white)
            }
        }.onTapGesture {
            currentGameState = .playing
        }
    }
}

extension Color {
    static let greenMenu = UIColor(named: "Green Menu")
    static let orangeMenu = UIColor(named: "Orange Menu")
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(currentGameState: .constant(.mainScreen)).previewInterfaceOrientation(.landscapeRight)
    }
}
