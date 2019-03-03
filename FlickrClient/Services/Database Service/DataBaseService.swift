//
//  DataBaseService.swift
//  FlickrClient
//
//  Created by Артур on 03/03/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation
import CoreData

enum ErrorsList: Error {
    case favouritesNotFound
    
}


class DataBaseService {
    
    //MARK: - Properties
    
    private lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "FlickrPhotoStorageModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var context = persistentContainer.viewContext
    
    private lazy var photosEntity = NSEntityDescription.entity(forEntityName: "FlickrPhotos", in: context)
    
    private lazy var backgroundContext = self.persistentContainer.newBackgroundContext()
    


    
    
    func saveFavourites(photo: IViewCellModel) {
     
        let newPhoto = FlickrPhotos(entity: self.photosEntity!, insertInto: self.backgroundContext)
        
        if photo.isFavorite && !self.isInFavorites(byUrl: photo.url) {
            
            newPhoto.id = photo.id
            newPhoto.title = photo.title
            newPhoto.url = photo.url
            newPhoto.isFavorite = photo.isFavorite
        }
        
        if !photo.isFavorite && self.isInFavorites(byUrl: photo.url) {
            
            self.deleteFromFavorites(byUrl: photo.url)
        
        }
        
        do {
            try self.backgroundContext.save()
            print("Saving Complete")
        } catch {
            print("Saving Faild")
            abort()
        }
        
        
    }
    
    //MARK: - IDatabaseService
    
    func loadFavourites() -> [NSManagedObject] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FlickrPhotos")
        var results: [NSManagedObject] = []
        do {
            results = try self.backgroundContext.fetch(fetchRequest) as! [NSManagedObject]
        } catch {
            print(error)
        }
        return results
    }
    
    
    private func isInFavorites(byUrl: String ) -> Bool {
   
        let fetchRequest = self.setupFetchRequest(ByAttribute: "url", ForValue: byUrl)
        var result = false
        
        do {
            let findFavorites = try backgroundContext.fetch(fetchRequest)
            if findFavorites.count == 0  { result = true }
        } catch {
            print("Failed")
        }
        
        return result
    }
    
    
    private func deleteFromFavorites(byUrl: String) {
        let fetchRequest = self.setupFetchRequest(ByAttribute: "url", ForValue: byUrl)
        
        
    }
    
    private func setupFetchRequest(ByAttribute: String, ForValue: String) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FlickrPhotos")
        fetchRequest.predicate = NSPredicate(format: "\(ByAttribute) = %@", "\(ForValue)")
        return fetchRequest
    }
    
    
}



