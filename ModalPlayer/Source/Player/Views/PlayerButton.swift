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
    
    var body: some View {
        if isPlaying {
            Circle()
                .fill(.yellow)
                .frame(maxWidth: 100)
                .overlay {
                    Image(systemName: "play.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 40)
                        .foregroundColor(.black)
                        .offset(x: 5)
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 1)) {
                        isPlaying = false
                    }
                }
        } else {
            Circle()
                .fill(.yellow)
                .frame(maxWidth: 100)
                .overlay {
                    Image(systemName: "pause.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 30)
                }
                .overlay {
                    Circle()
                        .stroke(.white, lineWidth: 2)
                        .padding(5)
                        .overlay {
                            Circle()
                                .trim(from: 0, to: progress)
                                .stroke(.black, lineWidth: 2)
                                .rotationEffect(.degrees(-90))
                                .padding(5)
                        }
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 1)) {
                        isPlaying = true
                    }
                }
        }
    }
}

struct PlayerButton_Previews: PreviewProvider {
    static var previews: some View {
        PlayerButton(isPlaying: .constant(false), progress: .constant(0.4))
    }
}
