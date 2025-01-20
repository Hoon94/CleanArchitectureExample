# 🏛️ MyCleanProject

## 📖 목차
1. [소개](#-소개)
2. [시각화된 프로젝트 구조](#-시각화된-프로젝트-구조)
3. [실행 화면](#-실행-화면)
4. [트러블 슈팅](#-트러블-슈팅)
5. [참고 링크](#-참고-링크)

</br>

## 🍀 소개
클린 아키텍처를 바탕으로 Github 유저 검색 및 즐겨찾기 기능을 지원하는 앱입니다.

* 주요 개념: `Clean Architecture`, `RxSwift`, `MVVM`

</br>

## 👀 시각화된 프로젝트 구조

```
📦 MyCleanProject
 ┣ 📂App
 ┣ 📂Presentation
 ┃ ┣ 📂View
 ┃ ┃ ┗ 📂Cell
 ┃ ┗ 📂ViewModel
 ┣ 📂Domain
 ┃ ┣ 📂RepositoryProtocol
 ┃ ┣ 📂UseCase
 ┃ ┗ 📂Entity
 ┣ 📂Data
 ┃ ┣ 📂Repository
 ┃ ┣ 📂CoreData
 ┃ ┗ 📂Network
 ┗ 📂Resources
```

### 📚 Architecture ∙ Framework ∙ Library

| Category| Name | Tag |
| ---| --- | --- |
| Architecture| Clean Architecture |  |
| | MVVM |  |
| Framework| UIKit | UI |
|Library | RxSwift | Data Binding |
| | Alamofire | Network |
| | Kingfisher | Image Fetching |
| | SnapKit | Layout |

</br>

## 💻 실행 화면 

| 시작 화면 | 유저 검색 |
|:--------:|:--------:|
|<img src="https://github.com/user-attachments/assets/8cdf179a-8053-4d6e-a410-75d9a3fa4b51" width="300">|<img src="https://github.com/user-attachments/assets/07194a67-b7db-4e0e-b2fa-ff2b73f4b0de" width="300">|

| 즐겨찾기 추가 및 삭제 | 검색어 업데이트 |
|:--------:|:--------:|
|<img src="https://github.com/user-attachments/assets/4250ff92-af34-4883-baed-fe65dae1f22d" width="300">|<img src="https://github.com/user-attachments/assets/608ea789-f698-4cf7-a386-4ebe05bb6786" width="300">|

</br>

## 🧨 트러블 슈팅

1️⃣ **UITableView 페이지네이션** <br>
-
🔒 **문제점** <br>
- 유저 검색 후 마지막까지 스크롤 할 시 다음 유저 목록을 받아오는 페이지네이션 방식에서 문제가 발생하였습니다.

    ```swift
    tableView.rx.prefetchRows.bind { [weak self] indexPath in
        guard let rows = self?.tableView.numberOfRows(inSection: 0), let itemIndex = indexPath.first?.row else { return }

        if itemIndex >= rows - 1 {
            self?.fetchMore.accept(())
        }

    }.disposed(by: disposeBag)
    ```

    위과 같이 코드를 작성시 if 조건문이 정상적으로 동작하지 않는 경우가 발생했습니다. 일반적인 경우 정상적으로 동작하는 경우도 있지만 페이지네이션을 위해 테이블 뷰를 매우 빠르게 스크롤하는 경우 다음과 같은 경우가 존재했습니다.
    
    <img src="https://github.com/user-attachments/assets/403919bd-2d6f-4028-9125-e71b310e225b" width="400">
    
    위 이미지의 출력 결과를 확인해 보면 itemIndex가 유저 목록 끝에서 전부 채워지지 않아 다음 유저 목록을 불러오지 못하는 문제가 발생하였습니다.

🔑 **해결방법** <br>
- 이를 위해 대표적인 페이지네이션 3가지 방식을 정리하였습니다.

    1. scrollViewDidScroll 사용
    
        스크롤을 아래로 내릴 때 더 이상 내려갈 곳이 없는 경우 데이터를 추가할 수 있습니다.

        ```swift
        func scrollViewDidScroll(_ scrollView: UIScrollView) {        
            let height: CGFloat = scrollView.frame.size.height            
            let contentYOffset: CGFloat = scrollView.contentOffset.y
            let scrollViewHeight: CGFloat = scrollView.contentSize.height
            let distanceFromBottom: CGFloat = scrollViewHeight - contentYOffset
            
            if distanceFromBottom < height {
                // 데이터 추가      
            }
        }
        ```
        
        예전부터 쓰던 고전적인 방법으로, 작동 방식이 확실하지만 마지막 목록까지 확인 후 새로운 데이터를 불러오기 때문에 스크롤을 빠르게 내릴 때 약간의 딜레이가 있는 것처럼 느껴질 수도 있습니다.

    2. willDisplayCell 사용
        TableView Willdisplay Cell 이라는 함수가 있습니다.

        ```swift
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if indexPath.row > dataList.count - 5 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if tableView.visibleCells.contains(cell) {
                        //데이터 추가
                    }
                }
            }
        }
        ```
        
        willDisplay 호출만으로는 cell이 화면에 보여졌다고 보장되지 않기 때문에 권장하는 방법은 아닙니다.

    3. TableView PrefetchRow 사용

        delegate 함수는 iOS버전 10부터 사용 가능합니다.

        ```swift
        tableview.prefetchDataSource = self // 대리자를 위임해 줘야합니다.
        
        func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
            for indexPath in indexPaths {
                if dataList.count == indexPath.row {
                    // 데이터 추가
                }
            }
        }
        ```
        
        서버 통신과 같은 비동기 상황에서 자연스럽게 pagination을 구현할 수 있는 함수입니다. 스택오버플로우에 따르면 용량이 큰 데이터나 퍼포먼스에 부담이 될 수 있는 작업에 효과적이라고 합니다.
        
    위와 같이 페이지네이션 방식을 정리해보고 다음과 같이 셀의 마지막 indexPath를 사용하여 코드를 수정하였습니다.
    
    ```swift
    tableView.rx.prefetchRows.bind { [weak self] indexPath in
        guard let rows = self?.tableView.numberOfRows(inSection: 0), let itemIndex = indexPath.last?.row else { return }

        if itemIndex >= rows - 1 {
            self?.fetchMore.accept(())
        }

    }.disposed(by: disposeBag)
    ```

<br>

2️⃣ **즐겨찾기 탭에서 페이지네이션 422 서버 에러** <br>
-
🔒 **문제점** <br>
- UserListViewController에서 `bindView()` 메서드에서 페이지네이션을 구현하고 있습니다.

    즐겨찾기 유저를 여러 명 추가 후 다시 앱을 실행했을 때, Core Data에 저장된 즐겨찾기 유저 목록은 그대로 표시됩니다. 이때 즐겨찾기 목록 테이블 뷰를 맨 밑으로 스크롤 하면 422 서버에러가 발생하는 문제가 있었습니다.

🔑 **해결방법** <br>
- 위 문제는 테이블 뷰의 맨 밑으로 스크롤 하면 바인딩 되어 있던 tableView의 prefetchRows(또는, willDisplayCell)의 페이지네이션 코드가 실행되고 fetchMore의 값이 변경되어 fetchUser()가 실행되었기 때문입니다. 이때 텍스트필드 값은 비어있기 때문에 데이터를 받아오는 과정에서 422 에러가 발생하는 것이 원인이었습니다.

    아래 코드와 같이 row를 받아 올 때, self?.tabButtonStackView.selectedType.value == .api를 추가하여 selectedType이 api 타입일 때만 fetchMore의 값이 변경되도록 수정하여 422 에러가 발생하는 문제를 해결할 수 있었습니다.

    ```swift
    tableView.rx.prefetchRows.bind { [weak self] indexPath in
        guard let rows = self?.tableView.numberOfRows(inSection: 0),
              let itemIndex = indexPath.last?.row,
              self?.tabButtonStackView.selectedType.value == .api
        else { return }

        if itemIndex >= rows - 1 {
            self?.fetchMore.accept(())
        }

    }.disposed(by: disposeBag)
    ```

<br>

3️⃣ **유저 검색창 입력에 맞춰 테이블 뷰 데이터 변경** <br>
-
🔒 **문제점** <br>
- 유저 검색에서 문자를 입력하면 문자에 맞춰 검색 쿼리가 전달되고 이에 따른 데이터로 테이블 뷰의 데이터 소스가 갱신됩니다. 하지만 검색을 하고 검색창의 문자열을 모두 지우는 경우 마지막 문자열에 대한 결과 값이 테이블 뷰에 남아있는 문제점이 있었습니다.

🔑 **해결방법** <br>
- 이를 해결하기 위해 다음과 같이 쿼리에 빈 값이 들어오면 fetchUserList의 값을 빈 배열로 변경해주었습니다. 기존에 유저의 정보를 담고 있던 fetchUserList에 빈 배열을 전달합니다. combineLatest 연산자에 의해 새로운 이벤트를 방출할 수 있어 최종적으로 빈 배열이 테이블 뷰의 데이터 소스로 전달됩니다.

    ```swift
    private let fetchUserList = BehaviorRelay<[UserListItem]>(value: [])

    guard let self = self, validateQuery(query: query) else {
        self?.getFavoriteUsers(query: "")
        self?.fetchUserList.accept([])
        return
    }

    let cellData: Observable<[UserListCellData]> = Observable.combineLatest(input.tabButtonType, fetchUserList, favoriteUserList, allFavoriteUserList)
    ```

</br>

## 📚 참고 링크
- [🍎Apple Docs: tableView(_:prefetchRowsAt:)](https://developer.apple.com/documentation/uikit/uitableviewdatasourceprefetching/tableview(_:prefetchrowsat:))
- [🍎Apple Docs: UITableViewDataSourcePrefetching](https://developer.apple.com/documentation/uikit/uitableviewdatasourceprefetching)
- [📘blog: RxSwift를 사용하여 가장 단순한 Pagination 처리 방법](https://ios-development.tistory.com/979)
</br>
