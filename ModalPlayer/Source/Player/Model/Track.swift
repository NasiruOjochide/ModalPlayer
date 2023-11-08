//
//  Track.swift
//  ModalPlayer
//
//  Created by Danjuma Nasiru on 07/11/2023.
//

import Foundation

public protocol Track: Equatable {
    var id: Int { get set }
    var artistName: String { get set }
    var trackTitle: String { get set }
    var trackURL: String { get set }
    var trackImage: URL? { get set }
}
