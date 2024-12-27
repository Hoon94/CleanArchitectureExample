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
}
