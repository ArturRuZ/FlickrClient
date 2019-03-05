//
//  DatabaseServiceProtocols.swift
//  FlickraTable
//
//  Created by Артур on 10/01/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation
import CoreData

protocol IDatabaseService: class{
    func loadObjectsFromBase() -> [NSManagedObject]
    func updateObjectsInBase(fromData: PhotosModel) 
}
