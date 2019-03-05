//
//  FavoritesInteractor.swift
//  FlickraTable
//
//  Created by Артур on 11/01/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


class FavoritesInteractor {
    private weak var interactorOutput : FavoritesInteractorOutput!
    var dataBaseAdapter : IDataBaseAdapter!
    
    deinit{
        print("deinit FavoritesInteractor")}
    
}


extension FavoritesInteractor : FavoritesInteractorInput{
    var output: FavoritesInteractorOutput {
        get {
            return interactorOutput
        }
        set {
            interactorOutput = newValue
        }
    }
}


extension FavoritesInteractor{
    func prepareData(){
        guard let preparedData = self.dataBaseAdapter?.getFavourites() else {return}
        interactorOutput.dataPrepared(data: preparedData)
    }
}

