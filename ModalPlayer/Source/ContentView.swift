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
        NavigationStack {
            VStack {
                Group{
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("Hello, world!")
                }
                .onTapGesture {
                    showPlayer = true
                }
                
                NavigationLink("Show all tracks") {
                    TracksListView()
                }
                .padding()
            }
            .padding()
            .sheet(isPresented: $showPlayer) {
                PlayerView()
                    .presentationDetents([.medium])
            }
            .navigationTitle("Home")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PlayerService())
    }
}
