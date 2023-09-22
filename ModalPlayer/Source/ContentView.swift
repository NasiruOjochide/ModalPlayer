//
//  ContentView.swift
//  ModalPlayer
//
//  Created by Danjuma Nasiru on 22/09/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showPlayer: Bool = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .onTapGesture {
            showPlayer = true
        }
        .sheet(isPresented: $showPlayer) {
            PlayerScreen()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
