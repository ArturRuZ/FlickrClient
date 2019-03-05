//
//  FlickraAssembly.swift
//  FlickraTable
//
//  Created by Артур on 27/12/2018.
//  Copyright © 2018 Артур. All rights reserved.
//

import Foundation
import UIKit

class AllPhotosAssembly {
    
    func build(internetService: InternetServiceInput, dataBaseAdapter: IDataBaseAdapter) -> (controller: UIViewController, presenter: FlickraPresenterInput)? {
        let storyboard = UIStoryboard(name: "FlickraStoryboard", bundle: nil)
        guard let flickraVC  = storyboard.instantiateViewController(withIdentifier: "kFlickraNavigationControllerIdentifier") as? FlickraViewController else {
            return nil}
       
        let presenter = AllPhotosPresenter()
        let interactor = AllPhotosInteractor()
        let photoStorage = PhotosStorage()
        
        flickraVC.output = presenter
        presenter.interactorInput = interactor
        presenter.viewInput = flickraVC
        interactor.output = presenter
        interactor.inputStorage = photoStorage
        photoStorage.storageOutput = interactor
        
        interactor.internetService = internetService
        interactor.dataBaseAdapter = dataBaseAdapter
        
        return (controller: flickraVC, presenter: presenter)
    }
    
    
    
}
