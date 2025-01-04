//
//  HeaderTableViewCell.swift
//  MyCleanProject
//
//  Created by Daehoon Lee on 1/4/25.
//

import SnapKit
import UIKit

final class HeaderTableViewCell: UITableViewCell, UserListCellProtocol {
    
    // MARK: - Static
    
    static let id = "HeaderTableViewCell"
    
    // MARK: - Properties
    
    private let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func apply(cellData: UserListCellData) {
        guard case .header(let title) = cellData else { return }
        
        titleLabel.text = title
    }
    
    private func setUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(20)
        }
    }
}
