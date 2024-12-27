//
//  UserListItem.swift
//  MyCleanProject
//
//  Created by Daehoon Lee on 12/27/24.
//

import Foundation

// MARK: - UserListResult

struct UserListResult: Decodable {
    
    // MARK: - Properties
    
    let totalCount: Int
    let incompleteResults: Bool
    let items: [UserListItem]
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
    
    // MARK: - Lifecycle
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.totalCount = try container.decode(Int.self, forKey: .totalCount)
        self.incompleteResults = try container.decode(Bool.self, forKey: .incompleteResults)
        self.items = try container.decode([UserListItem].self, forKey: .items)
    }
}

// MARK: - UserListItem

struct UserListItem: Decodable {
    
    // MARK: - Properties
    
    let id: Int
    let login: String
    let imageUrl: String
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case imageUrl = "avatar_url"
    }
    
    // MARK: - Lifecycle
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.login = try container.decode(String.self, forKey: .login)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
    }
}
