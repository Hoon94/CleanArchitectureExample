//
//  UserListViewController.swift
//  MyCleanProject
//
//  Created by Daehoon Lee on 12/27/24.
//

import UIKit

class UserListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: UserListViewModelProtocol
    
    // MARK: - Lifecycle
    
    init(viewModel: UserListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

