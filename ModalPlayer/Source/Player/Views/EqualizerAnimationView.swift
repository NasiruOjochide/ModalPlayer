//
//  EqualizerAnimationView.swift
//  ModalPlayer
//
//  Created by Danjuma Nasiru on 24/10/2023.
//

import SwiftUI

struct EqualizerAnimationView: View {
    @State private var columnHeight: CGFloat = 100
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack(alignment: .bottom) {
            ForEach(1..<5) { item in
                VStack {}
                    .frame(width: 30, height: (columnHeight / CGFloat (Int.random(in: 1...3))))
                .background(.red)
                .padding()
            }
        }
        .onReceive(timer) { time in
            columnHeight = CGFloat(Int.random(in: 30...100))
        }
    }
}

struct EqualizerAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        EqualizerAnimationView()
    }
}
