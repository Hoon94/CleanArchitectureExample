//
//  UserSession.swift
//  MyCleanProject
//
//  Created by Daehoon Lee on 12/29/24.
//

import Alamofire
import Foundation

// MARK: - SessionProtocol

public protocol SessionProtocol {
    func request(_ convertible: URLConvertible,
                 method: HTTPMethod,
                 parameters: Parameters?,
                 headers: HTTPHeaders?) -> DataRequest
}

// MARK: - UserSession

class UserSession: SessionProtocol {
    
    // MARK: - Properties
    
    private var session: Session
    
    // MARK: - Lifecycle
    
    init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = Session(configuration: config)
    }
    
    // MARK: - Helpers
    
    func request(_ convertible: URLConvertible,
                 method: HTTPMethod = .get,
                 parameters: Parameters? = nil,
                 headers: HTTPHeaders? = nil) -> DataRequest {
        return session.request(convertible, method: method, parameters: parameters, headers: headers)
    }
}
