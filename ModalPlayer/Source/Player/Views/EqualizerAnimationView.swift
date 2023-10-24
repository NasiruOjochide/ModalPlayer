//
//  EqualizerAnimationView.swift
//  ModalPlayer
//
//  Created by Danjuma Nasiru on 24/10/2023.
//

import SwiftUI

struct EqualizerAnimationView: View {
    
    @State private var columnHeight: CGFloat = 100
        
    var body: some View {
        HStack(alignment: .bottom) {
            ForEach(1..<5) { item in
                VStack {}
                    .frame(width: 30, height: (columnHeight / CGFloat (Int.random(in: 1...5))))
                .background(.red)
                .padding()
            }
        }
        .onAppear {
            withAnimation(.easeInOut.speed(0.4).repeatForever()) {
                columnHeight = CGFloat(Int.random(in: 50...100))
            }
        }
    }
}

struct EqualizerAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        EqualizerAnimationView()
    }
}
