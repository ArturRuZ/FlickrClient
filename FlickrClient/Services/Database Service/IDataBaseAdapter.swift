//
//  IDataBaseAdapter.swift
//  FlickrClient
//
//  Created by Артур on 04/03/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


protocol IDataBaseAdapter: class {
    
    func getFavourites() -> [PhotosModel]
    func updateFavourites(fromData: PhotosModel)
    
}
