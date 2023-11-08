//
//  TrackModel.swift
//  ModalPlayer
//
//  Created by Danjuma Nasiru on 20/10/2023.
//

import Foundation

struct TrackModel: Track {
    var id: Int
    var artistName: String
    var trackTitle: String
    var trackURL: String
    var trackImage: URL?
    
    static let exampleTrack: TrackModel = .init(id: 1, artistName: "Artist 1", trackTitle: "Sample 1", trackURL: "https://samples-files.com/samples/Audio/mp3/sample-file-4.mp3")
    static let exampleModels: [TrackModel] = [
        .init(id: 1, artistName: "Artist 1", trackTitle: "Sample 1", trackURL: "https://samples-files.com/samples/Audio/mp3/sample-file-4.mp3", trackImage: URL(string: "https://express-images.franklymedia.com/3745/sites/5/2020/02/18152003/FullSizeRender-1.jpeg")!),
        .init(id: 2, artistName: "Artist 2", trackTitle: "Sample 2", trackURL: "https://mp3bob.ru/download/muz/Rum-pum-pum.mp3"),
        .init(id: 3, artistName: "Artist 3", trackTitle: "Sample 3", trackURL: "https://download.samplelib.com/mp3/sample-9s.mp3")
    ]
}
