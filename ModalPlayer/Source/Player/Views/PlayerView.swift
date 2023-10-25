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
        .init(id: 1, artistName: "Artist 1", trackTitle: "Sample 1", trackURL: "https://samples-files.com/samples/Audio/mp3/sample-file-4.mp3"),
        .init(id: 2, artistName: "Artist 2", trackTitle: "Sample 2", trackURL: "https://mp3bob.ru/download/muz/Rum-pum-pum.mp3"),
        .init(id: 3, artistName: "Artist 3", trackTitle: "Sample 3", trackURL: "https://download.samplelib.com/mp3/sample-9s.mp3")
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                if playerService.currentTrack == nil {
                    Text("Click play button")
                } else {
                    Text(playerService.currentTrack?.artistName ?? "Unknown Artist")
                        .font(.title.bold())
                        .padding()
                    Text(playerService.currentTrack?.trackTitle ?? "No track Playing")
                        .italic()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack {
                Image(systemName: "backward.end.fill")
                    .onTapGesture {
                        playerService.rewindAction()
                    }
                
                PlayerButton(isPlaying: $playerService.musicIsPlaying, progress: $playerProgress) {
                    if !playerService.trackReadyToPlay {
                        playerService.startAudio(track: trackList[playerService.musicIndex])
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
