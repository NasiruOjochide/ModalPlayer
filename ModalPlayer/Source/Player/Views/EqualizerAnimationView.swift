//
//  EqualizerAnimationView.swift
//  ModalPlayer
//
//  Created by Danjuma Nasiru on 24/10/2023.
//

import SwiftUI

struct EqualizerAnimationView: View {
    
    @State private var evenColumnsHeight: CGFloat = 5
    @State private var oddColumnsHeight: CGFloat = 50
    
    var body: some View {
        HStack {
            ForEach(0..<4) { column in
                if column % 2 == 0 {
                    VStack {
                        Spacer()
                        VStack {}
                            .frame(width: 5, height: columnHeight(isEven: true))
                            .background(.red)
                            .padding(.horizontal, 2)
                    }
                } else {
                    VStack {
                        Spacer()
                        VStack {}
                            .frame(width: 5, height: columnHeight(isEven: false))
                            .background(.red)
                            .padding(.horizontal, 2)
                    }
                }
            }
        }
        .frame(height: 60)
        .onAppear {
            withAnimation(.easeInOut.speed(0.4).repeatForever()) {
                oddColumnsHeight = 5
                evenColumnsHeight = 50
            }
        }
        
    }
    
    func columnHeight(isEven: Bool) -> CGFloat {
        if isEven {
            return (evenColumnsHeight / CGFloat (Int.random(in: 1...3)))
        } else {
            return (oddColumnsHeight / CGFloat (Int.random(in: 1...3)))
        }
    }
}

struct EqualizerAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        EqualizerAnimationView()
    }
}
