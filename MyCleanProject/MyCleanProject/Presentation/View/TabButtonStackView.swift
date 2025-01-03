//
//  TabButtonStackView.swift
//  MyCleanProject
//
//  Created by Daehoon Lee on 1/3/25.
//

import RxCocoa
import RxSwift
import UIKit

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
