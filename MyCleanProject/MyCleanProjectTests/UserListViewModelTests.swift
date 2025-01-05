//
//  UserListViewModelTests.swift
//  MyCleanProjectTests
//
//  Created by Daehoon Lee on 1/5/25.
//

import RxCocoa
import RxSwift
import XCTest
@testable import MyCleanProject

final class UserListViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    private var mockUseCase: MockUserUseCase!
    private var viewModel: UserListViewModelProtocol!
    private var disposeBag: DisposeBag!
    
    private var tabButtonType: BehaviorRelay<TabButtonType>!
    private var query: BehaviorRelay<String>!
    private var saveFavorite: PublishRelay<UserListItem>!
    private var deleteFavorite: PublishRelay<Int>!
    private var fetchMore: PublishRelay<Void>!
    private var input: UserListViewModel.Input!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockUserUseCase()
        viewModel = UserListViewModel(useCase: mockUseCase)
        disposeBag = DisposeBag()
        
        // Input
        tabButtonType = BehaviorRelay(value: .api)
        query = BehaviorRelay(value: "")
        saveFavorite = PublishRelay()
        deleteFavorite = PublishRelay()
        fetchMore = PublishRelay()
        
        input = UserListViewModel.Input(tabButtonType: tabButtonType.asObservable(),
                                query: query.asObservable(),
                                saveFavorite: saveFavorite.asObservable(),
                                deleteFavorite: deleteFavorite.asObservable(),
                                fetchMore: fetchMore.asObservable())
    }
    
    override func tearDown() {
        mockUseCase = nil
        viewModel = nil
        disposeBag = nil
        super.tearDown()
    }
    
    // MARK: - Test
    
    func testFetchUserCellData() {
        // given
        let userList = [
            UserListItem(id: 1, login: "user1", imageUrl: ""),
            UserListItem(id: 2, login: "user2", imageUrl: ""),
            UserListItem(id: 3, login: "user3", imageUrl: "")
        ]
        
        mockUseCase.fetchUserResult = .success(UserListResult(totalCount: 3, incompleteResults: false, items: userList))
        
        // when
        let output = viewModel.transform(input: input)
        query.accept("user")
        var result = [UserListCellData]()
        
        output.cellData.bind { cellData in
            result = cellData
        }.disposed(by: disposeBag)
        
        // then
        if case .user(let userItem, _) = result.first {
            XCTAssertEqual(userItem.login, "user1")
        } else {
            XCTFail("Cell Data가 User Cell이 아님")
        }
    }
    
    func testFavoriteUserCellData() {
        // given
        let userList = [
            UserListItem(id: 1, login: "Ash", imageUrl: ""),
            UserListItem(id: 2, login: "Brown", imageUrl: ""),
            UserListItem(id: 3, login: "Brad", imageUrl: "")
        ]
        
        mockUseCase.favoriteUserResult = .success(userList)
        
        // when
        let output = viewModel.transform(input: input)
        tabButtonType.accept(.favorite)
        var result = [UserListCellData]()
        
        output.cellData.bind { cellData in
            result = cellData
        }.disposed(by: disposeBag)
        
        // then
        if case .header(let key) = result.first {
            XCTAssertEqual(key, "A")
        } else {
            XCTFail("Cell Data가 Header Cell이 아님")
        }
        
        if case .user(let userItem, let isFavorite) = result[1] {
            XCTAssertEqual(userItem.login, "Ash")
            XCTAssertTrue(isFavorite)
        } else {
            XCTFail("Cell Data가 User Cell이 아님")
        }
    }
}
