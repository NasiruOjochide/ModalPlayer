//
//  EqualizerAnimationView.swift
//  ModalPlayer
//
//  Created by Danjuma Nasiru on 24/10/2023.
//

import SwiftUI

struct EqualizerAnimationView: View {
    
    @State private var evenColumnsHeight: CGFloat = 30
    @State private var oddColumnsHeight: CGFloat = 100
    
    var body: some View {
        HStack {
            ForEach(0..<4) { column in
                if column % 2 == 0 {
                    VStack {
                        Spacer()
                        VStack {}
                            .frame(width: 30, height: (evenColumnsHeight / CGFloat (Int.random(in: 1...3))))
                            .background(.red)
                            .padding()
                    }
                } else {
                    VStack {
                        Spacer()
                        VStack {}
                            .frame(width: 30, height: (oddColumnsHeight / CGFloat (Int.random(in: 1...3))))
                            .background(.red)
                            .padding()
                    }
                }
            }
        }
        .frame(height: 200)
        .onAppear {
            withAnimation(.easeInOut.speed(0.4).repeatForever()) {
                oddColumnsHeight = 30
                evenColumnsHeight = 100
            }
        }
        
    }
}

struct EqualizerAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        EqualizerAnimationView()
    }
}
