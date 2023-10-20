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
        .init(id: 3, title: "Sample 3", url: "https://file-examples.com/storage/fef431be58652d8e49c225d/2017/11/file_example_MP3_700KB.mp3")
    ]
    
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
