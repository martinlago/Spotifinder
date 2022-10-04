//
//  SpotifinderApp.swift
//  Spotifinder
//
//  Created by Martín Lago on 29/9/22.
//

import SwiftUI

@main
struct SpotifinderApp: App {
       
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(HomeViewModel())
        }
    }
}
