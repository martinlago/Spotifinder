//
//  RequestError.swift
//  Spotifinder
//
//  Created by Martín Lago on 30/9/22.
//

import Foundation

enum RequestError<T: Any>: Error {
    case session(error: HTTPURLResponse)
    case decoding
    case encoding
    case validation(error: T)
    case other(Error)
    case urlError(reason: String)
    
    static func map(_ error: Error) -> RequestError<T> {
        switch error {
        case is Swift.DecodingError:
           return decoding
        case is Swift.EncodingError:
           return encoding
        case session(let httpURLError):
            return session(error: httpURLError)
        case let error as T:
            return validation(error: error)
        default:
           return .other(error)
       }
    }
}
