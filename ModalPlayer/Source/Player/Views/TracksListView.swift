//
//  TracksListView.swift
//  ModalPlayer
//
//  Created by Danjuma Nasiru on 24/10/2023.
//

import SwiftUI

struct TracksListView: View {
    
    @State private var showAnimation: Bool = true
    var trackList: [TrackModel] = TrackModel.exampleModels
    
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
