//
//  FlickrPhotos+CoreDataProperties.swift
//  FlickrClient
//
//  Created by Артур on 03/03/2019.
//  Copyright © 2019 Артур. All rights reserved.
//
//

import Foundation
import CoreData


extension FlickrPhotos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlickrPhotos> {
        return NSFetchRequest<FlickrPhotos>(entityName: "FlickrPhotos")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var isFavorite: Bool

}
