//
//  UserListViewModel.swift
//  MyCleanProject
//
//  Created by Daehoon Lee on 12/30/24.
//

import Foundation
import RxCocoa
import RxSwift

// MARK: - UserListViewModelProtocol

protocol UserListViewModelProtocol {
    
}

// MARK: - UserListViewModel

public final class UserListViewModel: UserListViewModelProtocol {
    
    // MARK: - Properties
    
    private let useCase: UserListUseCaseProtocol
    private let disposeBag = DisposeBag()
    private let error = PublishRelay<String>()
    private let fetchUserList = BehaviorRelay<[UserListItem]>(value: [])
    private let allFavoriteUserList = BehaviorRelay<[UserListItem]>(value: [])
    private let favoriteUserList = BehaviorRelay<[UserListItem]>(value: [])
    
    // MARK: - Input & Output
    
    public struct Input { // ViewModel에게 전달 되어야 할 이벤트
        let tabButtonType: Observable<TabButtonType>
        let query: Observable<String>
        let saveFavorite: Observable<UserListItem>
        let deleteFavorite: Observable<Int>
        let fetchMore: Observable<Void>
    }
    
    public struct Output { // ViewController에게 전달할 뷰 데이터
        let cellData: Observable<[UserListCellData]>
        let error: Observable<String>
    }
    
    // MARK: - Lifecycle
    
    init(useCase: UserListUseCaseProtocol) {
        self.useCase = useCase
    }
    
    // MARK: - Helpers
    
    public func transform(input: Input) -> Output {
        input.query.bind { [weak self] query in
            guard let isValidate = self?.validateQuery(query: query), isValidate else {
                self?.getFavoriteUsers(query: "")
                return
            }
            
            self?.fetchUser(query: query, page: 0)
            self?.getFavoriteUsers(query: query)
        }.disposed(by: disposeBag)
        
        input.saveFavorite
            .withLatestFrom(input.query, resultSelector: { users, query in
                return (users, query)
            })
            .bind { [weak self] user, query in
            self?.saveFavoriteUser(user: user, query: query)
        }.disposed(by: disposeBag)
        
        input.deleteFavorite
            .withLatestFrom(input.query, resultSelector: { ($0, $1) })
            .bind { [weak self] userId, query in
                self?.deleteFavoriteUser(userId: userId, query: query)
        }.disposed(by: disposeBag)
        
        input.fetchMore.bind {
            // TODO: 다음 페이지 검색
        }.disposed(by: disposeBag)
        
        let cellData: Observable<[UserListCellData]> = Observable.combineLatest(input.tabButtonType, fetchUserList, favoriteUserList).map { tabButtonType, fetchUserList, favoriteUserList in
            let cellData: [UserListCellData] = []
            // TODO: cellData 생성
            return cellData
        }
        
        return Output(cellData: cellData, error: error.asObservable())
    }
    
    private func fetchUser(query: String, page: Int) {
        guard let urlAllowedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        Task {
            let result = await useCase.fetchUser(query: urlAllowedQuery, page: page)
            
            switch result {
            case let .success(users):
                if page == 0 {
                    fetchUserList.accept(users.items)
                } else {
                    fetchUserList.accept(fetchUserList.value + users.items)
                }
            case let .failure(error):
                self.error.accept(error.description)
            }
        }
    }
    
    private func getFavoriteUsers(query: String) {
        let result = useCase.getFavoriteUsers()
        
        switch result {
        case .success(let users):
            if query.isEmpty {
                favoriteUserList.accept(users)
            } else {
                let filteredUsers = users.filter { user in
                    user.login.contains(query)
                }
                
                favoriteUserList.accept(filteredUsers)
            }
            
            allFavoriteUserList.accept(users)
        case .failure(let error):
            self.error.accept(error.description)
        }
    }
    
    private func saveFavoriteUser(user: UserListItem, query: String) {
        let result = useCase.saveFavoriteUser(user: user)
        
        switch result {
        case .success:
            getFavoriteUsers(query: query)
        case .failure(let error):
            self.error.accept(error.description)
        }
    }
    
    private func deleteFavoriteUser(userId: Int, query: String) {
        let result = useCase.deleteFavoriteUser(userId: userId)
        
        switch result {
        case .success:
            getFavoriteUsers(query: query)
        case .failure(let error):
            self.error.accept(error.description)
        }
    }
    
    private func validateQuery(query: String) -> Bool {
        if query.isEmpty {
            return false
        } else {
            return true
        }
    }
}

// MARK: - TabButtonType

public enum TabButtonType {
    case api
    case favorite
}

// MARK: - UserListCellData

public enum UserListCellData {
    case user(user: UserListItem, isFavorite: Bool)
    case header(String)
}
