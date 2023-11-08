//
//  PlayerViewConfig.swift
//  ModalPlayer
//
//  Created by Danjuma Nasiru on 07/11/2023.
//

import Foundation
import SwiftUI

public struct PlayerViewConfig {
    var tracklist: [ any Track ]
    var playerViewBackgroundColor: Color
    var playerButtonColor: Color
    
    static let exampleConfig: PlayerViewConfig = PlayerViewConfig(
        tracklist:
            TrackModel.exampleModels,
        playerViewBackgroundColor: .red,
        playerButtonColor: .yellow
    )
}
