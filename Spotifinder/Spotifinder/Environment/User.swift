//
//  User.swift
//  Spotifinder
//
//  Created by Martín Lago on 3/10/22.
//

import Foundation

class User: ObservableObject {

    static let shared = User()

    @Published var isLoggedIn: Bool = false

}
