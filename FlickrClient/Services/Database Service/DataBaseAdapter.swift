//
//  DataBaseAdapter.swift
//  FlickrClient
//
//  Created by Артур on 03/03/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation
import CoreData

class DataBaseAdapter {
    
    enum ErrorsFromDataBaseAdapter: Error {
        case convertFailed(String)
       
        
    }
    
    private var dataBaseService: IDatabaseService
    
    init (dataBaseService: IDatabaseService){
        self.dataBaseService = dataBaseService
    }
    
    private func convert<T>(data: [NSManagedObject]) throws -> T {
        
        if let flickrPhotos = data as? [FlickrPhotos] {
            var photosModel:[PhotosModel] = []
            for item in flickrPhotos {
            let photo = PhotosModel(id: item.id!, title: item.title!, url: item.url!, isFavorite: item.isFavorite)
            photosModel.append(photo)
            }
            guard let converted = photosModel as? T else {
                throw ErrorsFromDataBaseAdapter.convertFailed("Type doesn't match ")
            }
            return converted
        }
        throw ErrorsFromDataBaseAdapter.convertFailed("Converted Failed")
    }
    
    
}

extension DataBaseAdapter: IDataBaseAdapter {
    func getFavourites() -> [PhotosModel] {
    
        let objects = self.dataBaseService.loadObjectsFromBase()
    
        do {
            let photosModel: [PhotosModel] = try convert(data: objects)
            return photosModel
        } catch {
            print("Error in getFavourites()")
            return []
        }
        
    }
    
    func updateFavourites(fromData: PhotosModel) {
       self.dataBaseService.updateObjectsInBase(fromData: fromData)
    }
    
    
 
}
