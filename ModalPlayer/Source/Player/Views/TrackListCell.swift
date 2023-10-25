//
//  TrackListCell.swift
//  ModalPlayer
//
//  Created by Danjuma Nasiru on 24/10/2023.
//

import SwiftUI

struct TrackListCell: View {
    
    @State private var showAnimation: Bool = false
    @EnvironmentObject var playerService: PlayerService
    var track: TrackModel
    
    var body: some View {
        HStack {
            ZStack(alignment: .bottom) {
                if showAnimation {
                    EqualizerAnimationView()
                        .opacity(0.5)
                }
                VStack {
                    Image(systemName: "music.note")
                }
                .padding()
            }
            .frame(width: 60, height: 60)
            .border(.red, width: 1)
            .padding(.trailing)
            .onTapGesture {
                if playerService.currentTrack?.id == track.id {
                    if playerService.musicIsPlaying {
                        playerService.pause()
                        print("pause music")
                    } else {
                        playerService.play()
                        print("play music")
                    }
                } else {
                    playerService.pause()
                    playerService.startAudio(track: track)
                    print("music started")
                }
                
                showAnimation = playerService.musicIsPlaying
            }
            .onReceive(playerService.$musicIsPlaying, perform: { _ in
                if playerService.currentTrack != track {
                    showAnimation = false
                }
            })
            
            VStack(alignment: .leading) {
                Text(track.trackTitle)
                    .bold()
                Text(track.artistName)
                    .fontWeight(.light)
            }
        }
    }
}

struct TrackListCell_Previews: PreviewProvider {
    static var previews: some View {
        TrackListCell(track: .init(id: 1, artistName: "sample 1", trackTitle: "sample 1", trackURL: ""))
            .environmentObject(PlayerService())
    }
}
