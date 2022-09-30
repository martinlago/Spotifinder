//
//  APIConfig.swift
//  Spotifinder
//
//  Created by Martín Lago on 30/9/22.
//

import Foundation

class APIConfig {
    
    static func configure(base: String, path: String) -> URL {
        return URL(string: base)!.appendingPathComponent(path)
    }
    
}
