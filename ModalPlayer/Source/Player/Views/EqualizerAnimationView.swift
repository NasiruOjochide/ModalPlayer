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
                VStack {
                    Spacer()
                    VStack {}
                        .frame(width: 5, height: columnHeight(columnIndex: column))
                        .background(.red)
                        .padding(.horizontal, 2)
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
    
    func columnHeight(columnIndex: Int) -> CGFloat {
        var divisor = CGFloat(Int.random(in: 1...3))
        return columnIndex % 2 == 0 ? (evenColumnsHeight / divisor)
        : (oddColumnsHeight / divisor)
    }
}

struct EqualizerAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        EqualizerAnimationView()
    }
}
