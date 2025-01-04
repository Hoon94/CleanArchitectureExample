//
//  UserTableViewCell.swift
//  MyCleanProject
//
//  Created by Daehoon Lee on 1/3/25.
//

import Kingfisher
import RxSwift
import SnapKit
import UIKit

final class UserTableViewCell: UITableViewCell, UserListCellProtocol {
    
    // MARK: - Static
    
    static let id = "UserTableViewCell"
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    
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
    
    public let favoriteButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "heart"), for: .normal)
        button.setImage(.init(systemName: "heart.fill"), for: .selected)
        button.tintColor = .systemRed
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - Helpers
    
    func apply(cellData: UserListCellData) {
        guard case .user(let user, let isFavorite) = cellData else { return }
        
        userImageView.kf.setImage(with: URL(string: user.imageUrl))
        nameLabel.text = user.login
        favoriteButton.isSelected = isFavorite
    }
    
    private func setUI() {
        contentView.addSubview(userImageView)
        userImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(20)
            make.width.equalTo(80)
            make.height.equalTo(80).priority(.high)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView)
            make.leading.equalTo(userImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-20)
        }
    }
}
