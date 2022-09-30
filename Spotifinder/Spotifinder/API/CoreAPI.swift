//
//  CoreAPI.swift
//  Spotifinder
//
//  Created by Martín Lago on 30/9/22.
//

import Foundation
import Alamofire

final class CoreAPI {
    
    static let shared = CoreAPI()
    
    var sessionManager: Session?
    var requestList: [Request] = [Request]()
    
    init(configuration: URLSessionConfiguration = URLSessionConfiguration.af.default) {
        
        configuration.urlCache = nil
        let session = Session(configuration: configuration, delegate: SessionDelegate(), serverTrustManager: nil)
        sessionManager = session
    }
    
}
