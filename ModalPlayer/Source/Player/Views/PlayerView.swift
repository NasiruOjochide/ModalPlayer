//
//  PlayerScreen.swift
//  ModalPlayer
//
//  Created by Danjuma Nasiru on 22/09/2023.
//

import SwiftUI

struct PlayerView: View {
    
    @EnvironmentObject var playerService: PlayerService
    @State private var playerProgress: CGFloat = 0.0
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Text("Hello by Adele")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack {
                Image(systemName: "backward.end.fill")
                    .onTapGesture {
                        playerService.rewindMusic()
                    }
                
                PlayerButton(isPlaying: $playerService.isPlaying, progress: $playerProgress) {
                    if !playerService.musicLoaded {
                        playerService.startAudio()
                        playerService.musicLoaded = true
                    } else {
                        if playerService.isPlaying {
                            playerService.pause()
                        } else {
                            playerService.play()
                        }
                    }
                }
                .onReceive(playerService.publisher) { currentTime in
                    playerProgress = CGFloat(currentTime)
                }
                .padding()
                .frame(maxWidth: 80)
                
                Image(systemName: "forward.end.fill")
                    .onTapGesture {
                        playerService.nextMusic()
                    }
            }
            .padding()
        }
    }
}

struct PlayerScreen_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
            .environmentObject(PlayerService())
    }
}
