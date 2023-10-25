//
//  TracksListView.swift
//  ModalPlayer
//
//  Created by Danjuma Nasiru on 24/10/2023.
//

import SwiftUI

struct TracksListView: View {
    
    @State private var showAnimation: Bool = true
    var trackList: [TrackModel] = [
        .init(id: 1, artistName: "Artist 1", trackTitle: "Sample 1", trackURL: "https://samples-files.com/samples/Audio/mp3/sample-file-4.mp3"),
        .init(id: 2, artistName: "Artist 2", trackTitle: "Sample 2", trackURL: "https://mp3bob.ru/download/muz/Rum-pum-pum.mp3"),
        .init(id: 3, artistName: "Artist 3", trackTitle: "Sample 3", trackURL: "https://download.samplelib.com/mp3/sample-9s.mp3")
    ]
    
    var body: some View {
        List {
            ForEach(trackList, id: \.id) { track in
                TrackListCell(track: track)
            }
        }
    }
}

struct TracksListView_Previews: PreviewProvider {
    static var previews: some View {
        TracksListView()
            .environmentObject(PlayerService())
    }
}
