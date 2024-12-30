//
//  UserCoreData.swift
//  MyCleanProject
//
//  Created by Daehoon Lee on 12/30/24.
//

import CoreData
import Foundation

// MARK: - UserCoreDataProtocol

public protocol UserCoreDataProtocol {
    func getFavoriteUsers() -> Result<[UserListItem], CoreDataError>
    func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError>
    func deleteFavoriteUser(userId: Int) -> Result<Bool, CoreDataError>
}

// MARK: - UserCoreData

public struct UserCoreData: UserCoreDataProtocol {
    
    // MARK: - Properties
    
    private let viewContext: NSManagedObjectContext
    
    // MARK: - Lifecycle
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    // MARK: - Helpers
    
    public func getFavoriteUsers() -> Result<[UserListItem], CoreDataError> {
        let fetchRequest: NSFetchRequest<FavoriteUser> = FavoriteUser.fetchRequest()
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            let userList: [UserListItem] = result.compactMap { favoriteUser in
                guard let login = favoriteUser.login, let imageUrl = favoriteUser.imageUrl else { return nil }
                
                return UserListItem(id: Int(favoriteUser.id), login: login, imageUrl: imageUrl)
            }
            
            return .success(userList)
        } catch {
            return .failure(.readError(error.localizedDescription))
        }
    }
    
    public func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError> {
        guard let entity = NSEntityDescription.entity(forEntityName: "FavoriteUser", in: viewContext) else {
            return .failure(.entityNotFound("FavoriteUser"))
        }
        
        let userObject = NSManagedObject(entity: entity, insertInto: viewContext)
        userObject.setValue(user.id, forKey: "id")
        userObject.setValue(user.login, forKey: "login")
        userObject.setValue(user.imageUrl, forKey: "imageUrl")
        
        do {
            try viewContext.save()
            
            return .success(true)
        } catch {
            return .failure(.saveError(error.localizedDescription))
        }
    }
    
    public func deleteFavoriteUser(userId: Int) -> Result<Bool, CoreDataError> {
        let fetchRequest = FavoriteUser.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", userId)
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            
            result.forEach { favoriteUser in
                viewContext.delete(favoriteUser)
            }
            
            try viewContext.save()
            
            return .success(true)
        } catch {
            return .failure(.deleteError(error.localizedDescription))
        }
    }
}
