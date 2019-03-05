//
//  FlickraPresenter.swift
//  FlickraTable
//
//  Created by Артур on 27/12/2018.
//  Copyright © 2018 Артур. All rights reserved.
//

import Foundation
import UIKit

class AllPhotosPresenter {
    
    private weak var presenterDelegate : FlickraPresenterDelegate!
    private weak var view : FlickraViewInput!
    private var interactor: AllPhotosInteractorInput!
    
}

extension AllPhotosPresenter : FlickraPresenterInput {
    
    var output: FlickraPresenterDelegate {
        get {
            return presenterDelegate
        }
        set {
            presenterDelegate = newValue
        }
    }
    
    var viewInput: FlickraViewInput {
        get {
            return view
        }
        set {
            view = newValue
        }
        
    }
    
    var interactorInput: AllPhotosInteractorInput {
        get {
            return interactor
        }
        set {
            interactor = newValue
        }
    }
}


extension AllPhotosPresenter : FlickraInteractorOutput {
    func presentData(storage : [PhotosModel]){
        view.presentData(photosDataForView : storage)
    }
}


extension AllPhotosPresenter: FlickraViewOutput {
    func viewDidLoad() {
        interactorInput.getData()
    }
    func  rowSelected(selectedPhoto: PhotosModel) {
        presenterDelegate?.photoSelected(selectedPhoto: selectedPhoto)
    }
}


extension AllPhotosPresenter{
    
    func updateData(updateData: PhotosModel){
        interactor.updateData(updateData: updateData)
    }
    func favoritesButtonPressed(){
        presenterDelegate.showFavorites()
    }
}

