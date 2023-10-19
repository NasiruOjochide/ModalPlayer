//
//  ModalPlayerApp.swift
//  ModalPlayer
//
//  Created by Danjuma Nasiru on 22/09/2023.
//

import SwiftUI

@main
struct ModalPlayerApp: App {
    
    @StateObject var playerService = PlayerService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(playerService)
        }
    }
}
