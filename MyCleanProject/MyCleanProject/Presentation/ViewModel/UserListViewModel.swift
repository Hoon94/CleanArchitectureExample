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
        input.query.bind { query in
            // TODO: 상황에 맞춰서 user fetch or get favorite users
        }.disposed(by: disposeBag)
        
        input.saveFavorite.bind { user in
            // TODO: 즐겨찾기 추가
        }.disposed(by: disposeBag)
        
        input.deleteFavorite.bind { userId in
            // TODO: 즐겨찾기 삭제
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
