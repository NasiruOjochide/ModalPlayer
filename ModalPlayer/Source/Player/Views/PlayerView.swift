//
//  PlayerScreen.swift
//  ModalPlayer
//
//  Created by Danjuma Nasiru on 22/09/2023.
//

import SwiftUI

struct PlayerView: View {
    
    @EnvironmentObject var playerService: PlayerService
    var config: PlayerViewConfig?
    
    init(config: PlayerViewConfig?) {
        self.config = config
    }
    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    Spacer()
                    if playerService.currentTrack == nil {
                        Text("Click play button")
                    } else {
                        VStack {
                            if(playerService.currentTrack?.trackImage != nil) {
                                VStack {
                                    AsyncImage(url: playerService.currentTrack?.trackImage) {
                                        //trackImage($0)
                                        $0
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 200)
                                            .opacity(0.5)
                                    } placeholder: {
                                        trackImage(Image(systemName: "music.note"))
                                        
                                    }
                                    if playerService.currentTrack == nil {
                                        Text("Click play button")
                                    } else {
                                        Text(playerService.currentTrack?.artistName ?? "Unknown Artist")
                                            .font(.title.bold())
                                        Text(playerService.currentTrack?.trackTitle ?? "No track Playing")
                                            .italic()
                                    }
                                }
                            } else {
                                if playerService.currentTrack == nil {
                                    Text("Click play button")
                                } else {
                                    Text(playerService.currentTrack?.artistName ?? "Unknown Artist")
                                        .font(.title.bold())
                                    Text(playerService.currentTrack?.trackTitle ?? "No track Playing")
                                        .italic()
                                }
                            }
                        }
                        .padding()
                    }
                    Spacer()
                }
            }
            
            Spacer()
            
            HStack {
                Image(systemName: "backward.end.fill")
                    .onTapGesture {
                        playerService.rewindAction()
                    }
                    .foregroundColor(config?.playerButtonColor)
                
                PlayerButton(isPlaying: $playerService.musicIsPlaying, progress: $playerService.musicProgress, buttonColor: config?.playerButtonColor ?? .yellow) {
                    if !playerService.trackReadyToPlay {
                        guard !playerService.musicTracks.isEmpty else { return }
                        playerService.startAudio(track: playerService.musicTracks[playerService.musicIndex])
                    } else {
                        if playerService.musicIsPlaying {
                            playerService.pause()
                        } else {
                            playerService.play()
                        }
                    }
                }
                .padding()
                .frame(maxWidth: 80)
                
                Image(systemName: "forward.end.fill")
                    .onTapGesture {
                        playerService.nextMusic()
                    }
                    .foregroundColor(config?.playerButtonColor)
            }
            .padding(.bottom)
        }
        .onAppear {
            playerService.musicTracks = config?.tracklist ?? []
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(config?.playerViewBackgroundColor)
        .ignoresSafeArea()
    }
    
    func trackImage(_ image: Image) -> some View {
        image
            .resizable()
            .scaledToFit()
            .frame(width: 200)
            .opacity(0.5)
    }
}

struct PlayerScreen_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(config: PlayerViewConfig.exampleConfig)
        .environmentObject(PlayerService())
    }
}
