//
//  Movie.swift
//  IMDB Search
//
//  Created by Harish Kumar Annapureddy on 11/27/20.
//  Copyright © 2020 Harish Kumar Annapureddy. All rights reserved.
//

import Foundation

struct Movie{
    
    var link: String
    var genre: String
    var year: String
    var imageName: String
    var name: String
    
    init(data: [String: String]){
        self.link = data["imdbID"] ?? ""
        self.genre = data["Genre"] ?? ""
        self.year = data["Year"] ?? ""
        self.imageName = data["Poster"] ?? ""
        self.name = data["Title"] ?? ""
    }
    
}
