//
//  emuns.swift
//  IMDB Search
//
//  Created by Harish Kumar Annapureddy on 3/24/20.
//  Copyright © 2020 Harish Kumar Annapureddy. All rights reserved.
//

import Foundation

//APPError enum which shows all possible errors
enum APPError: Error {
    case networkError(Error)
    case dataNotFound
    case jsonParsingError(Error)
    case invalidStatusCode(Int)
}

//Result enum to show success or failure
enum Result<T> {
    case success(T)
    case failure(APPError)
}
