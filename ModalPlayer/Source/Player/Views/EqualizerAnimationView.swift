//
//  EqualizerAnimationView.swift
//  ModalPlayer
//
//  Created by Danjuma Nasiru on 24/10/2023.
//

import SwiftUI

struct EqualizerAnimationView: View {
    
    @State private var columnHeight: CGFloat = 30
    
    var body: some View {
        HStack {
            ForEach(0..<4) { _ in
                VStack {
                    Spacer()
                    VStack {}
                        .frame(width: 30, height: (columnHeight / CGFloat (Int.random(in: 1...3))))
                        .background(.red)
                        .padding()
                }
            }
        }
        .frame(height: 200)
        .onAppear {
            withAnimation(.easeInOut.speed(0.4).repeatForever()) {
                columnHeight = 100
            }
        }
        
    }
}

struct EqualizerAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        EqualizerAnimationView()
    }
}
