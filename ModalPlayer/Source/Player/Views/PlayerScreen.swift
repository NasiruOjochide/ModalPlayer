//
//  PlayerScreen.swift
//  ModalPlayer
//
//  Created by Danjuma Nasiru on 22/09/2023.
//

import SwiftUI

struct PlayerScreen: View {
    
    @State private var isPlaying: Bool = false
    @State private var playerProgress: CGFloat = 0.2
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Text("Hello by Adele")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            PlayerButton(isPlaying: $isPlaying, progress: $playerProgress)
                .padding()
                .frame(maxWidth: 80)
        }
    }
}

struct PlayerScreen_Previews: PreviewProvider {
    static var previews: some View {
        PlayerScreen()
    }
}
