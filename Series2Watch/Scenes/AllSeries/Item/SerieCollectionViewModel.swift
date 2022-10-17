//
//  SerieCollectionViewModel.swift
//  Series2Watch
//
//  Created by James Junior Chirinos Pinedo on 14/10/22.
//

import Foundation

struct SerieCollectionViewModel: Hashable {
    var id: Int
    var name: String?
    var imageUrl: String?
    
    init(serie: Serie) {
        self.id = serie.id
        self.name = serie.name
        self.imageUrl = serie.posterUrl
    }
}
