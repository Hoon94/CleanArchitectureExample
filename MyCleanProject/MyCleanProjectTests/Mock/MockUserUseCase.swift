//
//  MockUserUseCase.swift
//  MyCleanProjectTests
//
//  Created by Daehoon Lee on 1/5/25.
//

import Foundation
@testable import MyCleanProject

public class MockUserUseCase: UserListUseCaseProtocol {
    
    // MARK: - Properties
    
    public var fetchUserResult: Result<UserListResult, NetworkError>?
    public var favoriteUserResult: Result<[UserListItem], CoreDataError>?
    
    // MARK: - Helpers
    
    public func fetchUser(query: String, page: Int) async -> Result<MyCleanProject.UserListResult, MyCleanProject.NetworkError> {
        return fetchUserResult ?? .failure(.dataNil)
    }
    
    public func getFavoriteUsers() -> Result<[MyCleanProject.UserListItem], MyCleanProject.CoreDataError> {
        return favoriteUserResult ?? .failure(.entityNotFound(""))
    }
    
    public func saveFavoriteUser(user: MyCleanProject.UserListItem) -> Result<Bool, MyCleanProject.CoreDataError> {
        return .success(true)
    }
    
    public func deleteFavoriteUser(userId: Int) -> Result<Bool, MyCleanProject.CoreDataError> {
        return .success(true)
    }
    
    public func checkFavoriteState(fetchUsers: [UserListItem], favoriteUsers: [UserListItem]) -> [(user: UserListItem, isFavorite: Bool)] {
        let favoriteSet = Set(favoriteUsers)
        
        return fetchUsers.map { user in
            if favoriteSet.contains(user) {
                return (user: user, isFavorite: true)
            } else {
                return (user: user, isFavorite: false)
            }
        }
    }
    
    public func convertListToDictionary(favoriteUsers: [UserListItem]) -> [String : [UserListItem]] {
        return favoriteUsers.reduce(into: [String: [UserListItem]]()) { dictionary, user in
            if let firstString = user.login.first {
                let key = String(firstString).uppercased()
                dictionary[key, default: []].append(user)
            }
        }
    }
}
