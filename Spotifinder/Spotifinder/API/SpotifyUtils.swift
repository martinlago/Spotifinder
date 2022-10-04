//
//  SpotifyUtils.swift
//  Spotifinder
//
//  Created by Martín Lago on 1/10/22.
//

import Foundation
import UIKit
import Combine
import SpotifyWebAPI

final class SpotifyUtils: ObservableObject {

    private static let clientId: String = {
        if let clientId = ProcessInfo.processInfo
            .environment["CLIENT_ID"] {
            return clientId
        }
        return ""
    }()
    
    private static let clientSecret: String = {
        if let clientSecret = ProcessInfo.processInfo
            .environment["CLIENT_SECRET"] {
            return clientSecret
        }
        return ""
    }()
    
    let callbackUrl = URL(string: "spotifinder-app://login-callback")!
    
    // Provides protection against attacks such as cross-site request forgery
    var authorizationState = String.randomURLSafe(length: 128)
    
    @Published var isAuthorized = false
    
    let api = SpotifyAPI(
        authorizationManager: AuthorizationCodeFlowManager(
            clientId: SpotifyUtils.clientId,
            clientSecret: SpotifyUtils.clientSecret
        )
    )
    
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        
        self.api.authorizationManagerDidChange
            .receive(on: RunLoop.main)
            .sink(receiveValue: authorizeManagerDidChangeCallback)
            .store(in: &cancellables)

    }
    
    // Open browser to request user login
    func authorize() {

        let url = api.authorizationManager.makeAuthorizationURL(
            redirectURI: callbackUrl,
            showDialog: true,
            state: authorizationState,
            scopes: []
        )!
        
        UIApplication.shared.open(url)
    }
    
    func authorizeManagerDidChangeCallback() {
        print("Auth manager: \(self.api.authorizationManager)")
        
        User.shared.isLoggedIn = self.api.authorizationManager.isAuthorized()
    }
}
