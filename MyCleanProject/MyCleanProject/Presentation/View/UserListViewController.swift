//
//  UserListViewController.swift
//  MyCleanProject
//
//  Created by Daehoon Lee on 12/27/24.
//

import RxSwift
import SnapKit
import UIKit

class UserListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: UserListViewModelProtocol
    
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
    
    // MARK: - Lifecycle
    
    init(viewModel: UserListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
        setUI()
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
    }
}

final class TabButtonStackView: UIStackView {
    
    // MARK: - Properties
    
    private let tabList: [TabButtonType]
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    init(tabList: [TabButtonType]) {
        self.tabList = tabList
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
