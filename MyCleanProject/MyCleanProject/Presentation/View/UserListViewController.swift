//
//  UserListViewController.swift
//  MyCleanProject
//
//  Created by Daehoon Lee on 12/27/24.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

class UserListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: UserListViewModelProtocol
    private let saveFavorite = PublishRelay<UserListItem>()
    private let deleteFavorite = PublishRelay<Int>()
    private let fetchMore = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    private let searchTextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.cornerRadius = 6
        textField.placeholder = "검색어를 입력해 주세요"
        let imageView = UIImageView(image: .init(systemName: "magnifyingglass"))
        imageView.frame = .init(x: 0, y: 0, width: 20, height: 20)
        textField.leftView = imageView
        textField.leftViewMode = .always
        textField.tintColor = .black
        
        return textField
    }()
    
    private let tabButtonStackView = TabButtonStackView(tabList: [.api, .favorite])
    
    private let tableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    init(viewModel: UserListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
        setUI()
        bindView()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helpers
    
    private func setUI() {
        view.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        view.addSubview(tabButtonStackView)
        tabButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(tabButtonStackView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func bindView() {
        
    }
    
    private func bindViewModel() {
        let tabButtonType = tabButtonStackView.selectedType.compactMap { $0 }
        let query = searchTextField.rx.text.orEmpty.debounce(.milliseconds(300), scheduler: MainScheduler.instance)
        let output = viewModel.transform(input: UserListViewModel.Input(tabButtonType: tabButtonType, query: query, saveFavorite: saveFavorite.asObservable(), deleteFavorite: deleteFavorite.asObservable(), fetchMore: fetchMore.asObservable()))
        
        output.cellData.bind(to: tableView.rx.items) { tableView, index, item in            
            return UITableViewCell()
        }.disposed(by: disposeBag)
        
        output.error.bind { [weak self] errorMessage in
            let alert = UIAlertController(title: "에러", message: errorMessage, preferredStyle: .alert)
            alert.addAction(.init(title: "확인", style: .default))
            self?.present(alert, animated: true)
        }.disposed(by: disposeBag)
    }
}

final class TabButtonStackView: UIStackView {
    
    // MARK: - Properties
    
    private let tabList: [TabButtonType]
    private let disposeBag = DisposeBag()
    public let selectedType: BehaviorRelay<TabButtonType?>
    
    // MARK: - Lifecycle
    
    init(tabList: [TabButtonType]) {
        self.tabList = tabList
        self.selectedType = BehaviorRelay(value: tabList.first)
        super.init(frame: .zero)
        alignment = .fill
        distribution = .fillEqually
        
        addButtons()
        (arrangedSubviews.first as? UIButton)?.isSelected = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func addButtons() {
        tabList.forEach { tabType in
            let button = TabButton(type: tabType)
            
            button.rx.tap.bind { [weak self] in
                self?.arrangedSubviews.forEach { view in
                    (view as? UIButton)?.isSelected = false
                }
                
                button.isSelected = true
                self?.selectedType.accept(tabType)
            }.disposed(by: disposeBag)
            
            addArrangedSubview(button)
        }
    }
}

final class TabButton: UIButton {
    
    // MARK: - Properties
    
    private let type: TabButtonType
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = .systemCyan
            } else {
                backgroundColor = .white
            }
        }
    }
    
    // MARK: - Lifecycle
    
    init(type: TabButtonType) {
        self.type = type
        super.init(frame: .zero)
        setTitle(type.rawValue, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        setTitleColor(.black, for: .normal)
        setTitleColor(.white, for: .selected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
