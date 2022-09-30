//
//  DecoderUtils.swift
//  Spotifinder
//
//  Created by Martín Lago on 30/9/22.
//

import Foundation
import Alamofire
import Combine

extension JSONDecoder {
    
    func handleResponse<T: Decodable>(_ type: T.Type, from response: DataResponse<T, AFError>) -> Result<T, RequestError<Any>> {
        
        guard response.error == nil else {
            switch response.result {
            case .failure(let err):
                if err._code == NSURLErrorTimedOut { // TODO: - will change
                    return .failure(RequestError<Any>.validation(error: response.error!))
                } else {
                    return .failure(RequestError<Any>.validation(error: response.error!))
                }
            case .success:
                return .failure(RequestError<Any>.validation(error: response.error!))
            }
        }
            
        guard response.data != nil else {
            return .failure(RequestError<Any>.validation(error: response.error!))
        }
        
        do {
            let item = try decode(T.self, from: response.data!)
            return .success(item)
        } catch {
            return .failure(RequestError<Any>.validation(error: Swift.DecodingError.self))
        }
    }
}
