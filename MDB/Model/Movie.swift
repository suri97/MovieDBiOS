//
//  Movie.swift
//  MDB
//
//  Created by Suruchi Chopra on 30/12/17.
//  Copyright © 2017 Suransh Chopra. All rights reserved.
//

import UIKit

class Movie: NSObject, Codable {
    
    let id: Int64
    let title: String
    let poster_path: String
    let release_date: String
    
    init(id: Int64, title: String, poster_path: String,release_date: String) {
        self.id = id
        self.title = title
        self.poster_path = poster_path
        self.release_date = release_date
    }
    
}

class MovieJson: NSObject, Codable {
    let results: [Movie]
    init(results: [Movie]) {
        self.results = results
    }
}
