//
//  PlayerScreen.swift
//  ModalPlayer
//
//  Created by Danjuma Nasiru on 22/09/2023.
//

import SwiftUI

struct PlayerScreen: View {
    
    @EnvironmentObject var playerService: PlayerService
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
                        playerService.startAudio()
                        musicLoaded = true
                    } else {
                        if isPlaying {
                            playerService.pause()
                        } else {
                            playerService.play()
                        }
                    }
                }
                .onReceive(playerService.publisher) { currentTime in
                    playerProgress = CGFloat(currentTime)
                }
                .onReceive(playerService.musicEnded) { value in
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
