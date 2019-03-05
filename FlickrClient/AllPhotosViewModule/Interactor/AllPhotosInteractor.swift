//
//  FlickraInteractor.swift
//  FlickraTable
//
//  Created by Артур on 27/12/2018.
//  Copyright © 2018 Артур. All rights reserved.
//

import Foundation

class AllPhotosInteractor {
    private weak var interactorOutput : FlickraInteractorOutput!
    private var storageInput : PhotosStorageInput!
    var internetService: InternetServiceInput!
    var dataBaseAdapter : IDataBaseAdapter!
    private var isFirstRun = false
}

extension AllPhotosInteractor : AllPhotosInteractorInput {
    var inputStorage: PhotosStorageInput {
        get {
            return storageInput
        }
        set {
            storageInput = newValue
        }
    }
    
    var output: FlickraInteractorOutput {
        get {
            return interactorOutput
        }
        set {
            interactorOutput = newValue
        }
    }
    
    func getData() {
        downloadData()
    }
    
}


extension AllPhotosInteractor : PhotosStorageOutput {
    func presentData(storage: [PhotosModel]) {
       
      let favourites = self.dataBaseAdapter.getFavourites()
        var favouritesUrl: [String] = []
        favourites.map {favouritesUrl.append($0.url)}
         storage.map {
             if let _ = favouritesUrl.firstIndex(of: $0.url) {
                $0.isFavorite = true
            }
        }
        interactorOutput.presentData(storage: storage)
    }
}





extension AllPhotosInteractor {
    private func downloadData() {
        let url = URL(string: "https://www.flickr.com/services/rest?method=flickr.interestingness.getList&api_key=3988023e15f45c8d4ef5590261b1dc53&per_page=40&page=1&format=json&nojsoncallback=1&extras=url_l&date=2018-09-23")
        internetService.loadData(fromURL: url, parseInto: PhotosResponse.self, success: { (response: PhotosResponse) in
            self.storageInput.saveData(parsedData: response)
        }) { (code) in
            print("Error")
        }
    }
    
    func updateData(updateData: PhotosModel) {
        storageInput.updateData(updateData:updateData)
        self.dataBaseAdapter.updateFavourites(fromData: updateData)
        
    }
}

