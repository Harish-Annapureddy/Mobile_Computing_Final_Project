//
//  File1.swift
//  IMDB Search
//
//  Created by Harish Kumar Annapureddy on 3/24/20.
//  Copyright © 2020 Harish Kumar Annapureddy. All rights reserved.
//

import Foundation

import Foundation

struct MovieData : Codable {

    let response : String?
    let search : [Search]?
    let totalResults : String?
    let error : String?
    
    enum CodingKeys: String, CodingKey {
        case response = "Response"
        case search = "Search"
        case totalResults = "totalResults"
        case error = "Error"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        response = try values.decodeIfPresent(String.self, forKey: .response)
        search = try values.decodeIfPresent([Search].self, forKey: .search)
        totalResults = try values.decodeIfPresent(String.self, forKey: .totalResults)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }

}

struct Search : Codable {

    let imdbID : String?
    let poster : String?
    let title : String?
    let type : String?
    let year : String?

    enum CodingKeys: String, CodingKey {
        case imdbID = "imdbID"
        case poster = "Poster"
        case title = "Title"
        case type = "Type"
        case year = "Year"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        imdbID = try values.decodeIfPresent(String.self, forKey: .imdbID)
        poster = try values.decodeIfPresent(String.self, forKey: .poster)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        year = try values.decodeIfPresent(String.self, forKey: .year)
    }

}
