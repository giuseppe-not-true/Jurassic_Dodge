//
//  AudioPlayer.swift
//  Jurassic Dodge
//
//  Created by Giuseppe Falso on 12/05/22.
//

import Foundation
import AVFoundation

class AudioPlayer {
    var backgroundMusicPlayer: AVAudioPlayer!
//    (contentsOf: URL(fileURLWithPath: sound!))
    
    init() {
        let sound = Bundle.main.path(forResource: "meteor shower", ofType: "wav")
        let url = URL(fileURLWithPath: sound!)
        
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            // couldn't load file :(
        }
    }
    
    func playBackgroundMusic() {
        backgroundMusicPlayer.play()
    }
    
    func stopBackgroundMusic() {
        backgroundMusicPlayer.pause()
        backgroundMusicPlayer.currentTime = 0
    }
}
