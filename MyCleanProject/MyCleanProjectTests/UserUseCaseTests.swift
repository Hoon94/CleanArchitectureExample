//
//  UserUseCaseTests.swift
//  MyCleanProjectTests
//
//  Created by Daehoon Lee on 12/30/24.
//

import XCTest
@testable import MyCleanProject

final class UserUseCaseTests: XCTestCase {
    
    // MARK: - Properties
    
    var useCase: UserListUseCaseProtocol!
    var repository: UserRepositoryProtocol!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        repository = MockUserRepository()
        useCase = UserListUseCase(repository: repository)
    }
    
    override func tearDown() {
        repository = nil
        useCase = nil
        super.tearDown()
    }
    
    // MARK: - Test
    
    func testCheckFavoriteState() {
        // given
        let favoriteUsers = [
            UserListItem(id: 1, login: "user1", imageUrl: ""),
            UserListItem(id: 2, login: "user2", imageUrl: "")
        ]
        
        let fetchUsers = [
            UserListItem(id: 1, login: "user1", imageUrl: ""),
            UserListItem(id: 3, login: "user3", imageUrl: "")
        ]
        
        // when
        let result = useCase.checkFavoriteState(fetchUsers: fetchUsers, favoriteUsers: favoriteUsers)
        
        // then
        XCTAssertEqual(result[0].isFavorite, true)
        XCTAssertEqual(result[1].isFavorite, false)
    }
    
    func testConvertListToDictionary() {
        // given
        let users = [
            UserListItem(id: 1, login: "Alice", imageUrl: ""),
            UserListItem(id: 2, login: "Bob", imageUrl: ""),
            UserListItem(id: 3, login: "Charlie", imageUrl: ""),
            UserListItem(id: 4, login: "ash", imageUrl: ""),
        ]
        
        // when
        let result = useCase.convertListToDictionary(favoriteUsers: users)
        
        // then
        XCTAssertEqual(result.keys.count, 3)
        XCTAssertEqual(result["A"]?.count, 2)
        XCTAssertEqual(result["B"]?.count, 1)
        XCTAssertEqual(result["C"]?.count, 1)
    }
}
