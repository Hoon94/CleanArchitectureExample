//
//  MockUserRepository.swift
//  MyCleanProjectTests
//
//  Created by Daehoon Lee on 12/30/24.
//

import Foundation
@testable import MyCleanProject

public struct MockUserRepository: UserRepositoryProtocol {
    
    // MARK: - Helpers
    
    public func fetchUser(query: String, page: Int) async -> Result<MyCleanProject.UserListResult, MyCleanProject.NetworkError> {
        .failure(.dataNil)
    }
    
    public func getFavoriteUsers() -> Result<[MyCleanProject.UserListItem], MyCleanProject.CoreDataError> {
        .failure(.entityNotFound(""))
    }
    
    public func saveFavoriteUser(user: MyCleanProject.UserListItem) -> Result<Bool, MyCleanProject.CoreDataError> {
        .failure(.entityNotFound(""))
    }
    
    public func deleteFavoriteUser(userId: Int) -> Result<Bool, MyCleanProject.CoreDataError> {
        .failure(.entityNotFound(""))
    }
}
