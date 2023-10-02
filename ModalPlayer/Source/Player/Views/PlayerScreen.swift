//
//  PlayerScreen.swift
//  ModalPlayer
//
//  Created by Danjuma Nasiru on 22/09/2023.
//

import SwiftUI

struct PlayerScreen: View {
    
    @State private var isPlaying: Bool = false
    @State private var musicLoaded: Bool = false
    @State private var playerProgress: CGFloat = 0.0
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Text("Hello by Adele")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack {
                PlayerButton(isPlaying: $isPlaying, progress: $playerProgress) {
                    if !musicLoaded {
                        PlayerService.shared.startAudio()
                        musicLoaded = true
                    } else {
                        if isPlaying {
                            PlayerService.shared.pause()
                        } else {
                            PlayerService.shared.play()
                        }
                    }
                }
                .onReceive(PlayerService.shared.publisher) { currentTime in
                    playerProgress = CGFloat(currentTime)
                }
                .onReceive(PlayerService.shared.musicEnded) { value in
                    if value {
                        isPlaying = false
                    }
                }
                .padding()
                .frame(maxWidth: 80)
            }
        }
    }
}

struct PlayerScreen_Previews: PreviewProvider {
    static var previews: some View {
        PlayerScreen()
    }
}
