//
//  TVShows.swift
//  MDB
//
//  Created by Suruchi Chopra on 05/01/18.
//  Copyright © 2018 Suransh Chopra. All rights reserved.
//

import UIKit

class TVShows: NSObject, Codable {

    let id: Int64
    let original_name: String
    var poster_path: String?
    let first_air_date: String
    let genre_ids: [Int]
    
    init(id: Int64, original_name: String, poster_path: String?,first_air_date: String,genre_ids: [Int]) {
        self.id = id
        self.original_name = original_name
        self.poster_path = poster_path
        self.first_air_date = first_air_date
        self.genre_ids = genre_ids
    }
}

class TVJson: NSObject, Codable {
    let results: [TVShows]
    init(results: [TVShows]) {
        self.results = results
    }
}
