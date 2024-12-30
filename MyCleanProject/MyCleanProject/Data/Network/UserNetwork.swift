//
//  UserNetwork.swift
//  MyCleanProject
//
//  Created by Daehoon Lee on 12/30/24.
//

import Foundation

final public class UserNetwork {
    
    // MARK: - Properties
    
    private let manager: NetworkManagerProtocol
    
    // MARK: - Lifecycle
    
    init(manager: NetworkManagerProtocol) {
        self.manager = manager
    }
    
    // MARK: - Helpers
    
    func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> {
        let url = "https://api.github.com/search/users?q=\(query)&page=\(page)"
        
        return await manager.fetchData(url: url, method: .get, parameters: nil)
    }
}
