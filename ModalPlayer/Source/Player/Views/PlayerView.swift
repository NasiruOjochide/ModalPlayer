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
    @State private var trackList: [TrackModel] = [
        .init(id: 1, title: "Sample 1", url: "https://samples-files.com/samples/Audio/mp3/sample-file-4.mp3"),
        .init(id: 2, title: "Sample 2", url: "https://mp3bob.ru/download/muz/Rum-pum-pum.mp3"),
        .init(id: 3, title: "Sample 3", url: "https://download.samplelib.com/mp3/sample-9s.mp3")
    ]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Text(playerService.currentTrack?.title ?? "No track Playing")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack {
                Image(systemName: "backward.end.fill")
                    .onTapGesture {
                        playerService.rewindAction()
                    }
                
                PlayerButton(isPlaying: $playerService.musicIsPlaying, progress: $playerProgress) {
                    if !playerService.trackReadyToPlay {
                        playerService.startAudio()
                        playerService.trackReadyToPlay = true
                    } else {
                        if playerService.musicIsPlaying {
                            playerService.pause()
                        } else {
                            playerService.play()
                        }
                    }
                }
                .onReceive(playerService.musicProgressPublisher) { currentTime in
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
        .onAppear {
            playerService.musicTracks = trackList
        }
    }
}

struct PlayerScreen_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
            .environmentObject(PlayerService())
    }
}
