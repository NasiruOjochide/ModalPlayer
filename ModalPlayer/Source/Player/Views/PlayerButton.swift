//
//  PlayerButton.swift
//  ModalPlayer
//
//  Created by Danjuma Nasiru on 22/09/2023.
//

import SwiftUI

struct PlayerButton: View {
    
    @Binding var isPlaying: Bool
    @Binding var progress: CGFloat
    var buttonColor: Color = .yellow
    var playSound: () -> Void
    
    var body: some View {
        Circle()
            .fill(buttonColor)
            .overlay {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
            }
            .overlay {
                if isPlaying {
                    Circle()
                        .stroke(.white, lineWidth: 2)
                        .padding(2)
                        .overlay {
                            Circle()
                                .trim(from: 0, to: progress)
                                .stroke(.black, lineWidth: 2)
                                .rotationEffect(.degrees(-90))
                                .padding(2)
                        }
                }
            }
            .onTapGesture {
                playSound()
            }
        
    }
}

struct PlayerButton_Previews: PreviewProvider {
    static var previews: some View {
        PlayerButton(isPlaying: .constant(true), progress: .constant(0.4), playSound: {})
    }
}
