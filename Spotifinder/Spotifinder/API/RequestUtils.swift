//
//  RequestUtils.swift
//  Spotifinder
//
//  Created by Martín Lago on 30/9/22.
//

import Foundation
import Alamofire

public struct CoreCommonBuilder {
    
    struct BuildData {
        var base: String
        var path: String
        var parameters: Parameters?
        var method: HTTPMethod = .get
        var headers: HTTPHeaders?
        var encoding: ParameterEncoding = URLEncoding.default
        var body: Data?
        var requestBasicAuth: String?
    }
    
    static func buildRequest(data: BuildData) -> URLRequestConvertible? {
        
        let url = APIConfig.configure(base: data.base, path: data.path)
        
        do {
            var originalRequest = try URLRequest(url: url, method: data.method, headers: data.headers)
            if let value = data.requestBasicAuth {
                originalRequest.setValue("\(value)", forHTTPHeaderField: "Authorization")
            }
            if let value = data.body {
                originalRequest.setValue("application/json",
                                            forHTTPHeaderField: "Content-Type")
                originalRequest.setValue("application/json",
                                            forHTTPHeaderField: "Accept")
                originalRequest.httpBody = value
            } else {
                return try data.encoding.encode(originalRequest, with: data.parameters)
            }
            
            return originalRequest
        } catch {
            return nil
        }
        
    }
    
}
