//
//  ContentView.swift
//  Spotifinder
//
//  Created by Martín Lago on 29/9/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var spotifyUtils: SpotifyUtils
    
    var body: some View {
        Button {
            spotifyUtils.authorize()
        } label: {
            Text("Log in to Spotify")
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
