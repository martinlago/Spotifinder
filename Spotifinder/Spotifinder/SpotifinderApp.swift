//
//  SpotifinderApp.swift
//  Spotifinder
//
//  Created by Martín Lago on 29/9/22.
//

import SwiftUI

@main
struct SpotifinderApp: App {
    
    @StateObject var spotify = SpotifyUtils()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(spotify)
        }
    }
}
