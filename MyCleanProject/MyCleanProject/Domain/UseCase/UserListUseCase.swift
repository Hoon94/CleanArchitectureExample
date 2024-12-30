//
//  UserListUseCase.swift
//  MyCleanProject
//
//  Created by Daehoon Lee on 12/28/24.
//

import Foundation

// MARK: - UserListUseCaseProtocol

public protocol UserListUseCaseProtocol {
    func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> // 유저 리스트 불러오기 (원격)
    func getFavoriteUsers() -> Result<[UserListItem], CoreDataError> // 전체 즐겨찾기 리스트 불러오기
    func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError>
    func deleteFavoriteUser(userId: Int) -> Result<Bool, CoreDataError>
    func checkFavoriteState(fetchUsers: [UserListItem], favoriteUsers: [UserListItem]) -> [(user: UserListItem, isFavorite: Bool)] // 즐겨찾기에 포함된 유저인지 확인
    func convertListToDictionary(favoriteUsers: [UserListItem]) -> [String: [UserListItem]] // 초성을 키로 딕셔너리 변환
}

// MARK: - UserListUseCase

public struct UserListUseCase: UserListUseCaseProtocol {
    
    // MARK: - Properties
    
    private let repository: UserRepositoryProtocol
    
    // MARK: - Lifecycle
    
    public init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Helpers
    
    public func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> {
        await repository.fetchUser(query: query, page: page)
    }
    
    public func getFavoriteUsers() -> Result<[UserListItem], CoreDataError> {
        repository.getFavoriteUsers()
    }
    
    public func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError> {
        repository.saveFavoriteUser(user: user)
    }
    
    public func deleteFavoriteUser(userId: Int) -> Result<Bool, CoreDataError> {
        repository.deleteFavoriteUser(userId: userId)
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
