//
//  UserTableViewCell.swift
//  MyCleanProject
//
//  Created by Daehoon Lee on 1/3/25.
//

import Kingfisher
import SnapKit
import UIKit

final class UserTableViewCell: UITableViewCell {
    
    // MARK: - Static
    
    static let id = "UserTableViewCell"
    
    // MARK: - Properties
    
    private let userImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let nameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 2
        
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
        guard case .user(let user, let isFavorite) = cellData else { return }
        
        userImageView.kf.setImage(with: URL(string: user.imageUrl))
        nameLabel.text = user.login
    }
    
    private func setUI() {
        addSubview(userImageView)
        userImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(20)
            make.width.height.equalTo(80)
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView)
            make.leading.equalTo(userImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(20)
        }
    }
}
