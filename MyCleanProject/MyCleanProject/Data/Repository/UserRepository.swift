//
//  UserRepository.swift
//  MyCleanProject
//
//  Created by Daehoon Lee on 12/30/24.
//

import Foundation

public struct UserRepository: UserRepositoryProtocol {
    
    // MARK: - Properties
    
    private let coreData: UserCoreDataProtocol
    private let network: UserNetworkProtocol
    
    // MARK: - Lifecycle
    
    init(coreData: UserCoreDataProtocol, network: UserNetworkProtocol) {
        self.coreData = coreData
        self.network = network
    }
    
    // MARK: - Helpers
    
    public func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> {
        return await network.fetchUser(query: query, page: page)
    }
    
    public func getFavoriteUsers() -> Result<[UserListItem], CoreDataError> {
        return coreData.getFavoriteUsers()
    }
    
    public func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError> {
        return coreData.saveFavoriteUser(user: user)
    }
    
    public func deleteFavoriteUser(userId: Int) -> Result<Bool, CoreDataError> {
        return coreData.deleteFavoriteUser(userId: userId)
    }
}
