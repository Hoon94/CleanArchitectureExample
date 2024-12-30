//
//  UserNetwork.swift
//  MyCleanProject
//
//  Created by Daehoon Lee on 12/30/24.
//

import Foundation

// MARK: - UserNetworkProtocol

public protocol UserNetworkProtocol {
    func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError>
}

// MARK: - UserNetwork

final public class UserNetwork: UserNetworkProtocol {
    
    // MARK: - Properties
    
    private let manager: NetworkManagerProtocol
    
    // MARK: - Lifecycle
    
    init(manager: NetworkManagerProtocol) {
        self.manager = manager
    }
    
    // MARK: - Helpers
    
    public func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> {
        let url = "https://api.github.com/search/users?q=\(query)&page=\(page)"
        
        return await manager.fetchData(url: url, method: .get, parameters: nil)
    }
}
