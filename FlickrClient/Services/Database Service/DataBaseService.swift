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
    


    
    
    func updateFavourites(photo: PhotosModel) {
        
        switch photo.isFavorite {
        case true:
             self.addInFavorites(photo: photo)
        case false:
             self.deleteFromFavorites(byUrl: photo.url)
        }
    }
    
    //MARK: - IDatabaseService
    
   private func loadFavourites() -> [NSManagedObject] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FlickrPhotos")
        var results: [NSManagedObject] = []
        do {
            results = try self.backgroundContext.fetch(fetchRequest) as! [NSManagedObject]
        } catch {
            print(error)
        }
        return results
    }
    
    private func addInFavorites(photo: PhotosModel){
        
        let newPhoto = FlickrPhotos(entity: self.photosEntity!, insertInto: self.backgroundContext)
        newPhoto.id = photo.id
        newPhoto.title = photo.title
        newPhoto.url = photo.url
        newPhoto.isFavorite = photo.isFavorite
        
        do {
            try self.backgroundContext.save()
            print("Saving Complete")
        } catch {
            print("Saving Faild")
            abort()
        }
        
    }
    
    /*
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
    */
    
    private func deleteFromFavorites(byUrl: String) {
        let fetchRequest = self.setupFetchRequest(ByAttribute: "url", ForValue: byUrl)
        
        do {
            guard let findFavorites = try backgroundContext.fetch(fetchRequest) as? [NSManagedObject] else {return}
                for item in findFavorites {
                    backgroundContext.delete(item) }
        } catch {
            print("Deleting Failed")
        }
        do {
            try self.backgroundContext.save()
            print("Saving Complete")
        } catch {
            print("Saving Faild")
            abort()
        }
        
    }
    
    private func setupFetchRequest(ByAttribute: String, ForValue: String) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FlickrPhotos")
        fetchRequest.predicate = NSPredicate(format: "\(ByAttribute) = %@", "\(ForValue)")
        fetchRequest.returnsObjectsAsFaults = false
        return fetchRequest
    }
    
}

extension DataBaseService: IDatabaseService{
    func loadObjectsFromBase() -> [NSManagedObject] {
        return self.loadFavourites()
    }
    
    func updateObjectsInBase(fromData: PhotosModel) {
        self.updateFavourites(photo: fromData)
    }
    
    
    
    
    
}

