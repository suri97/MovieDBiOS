//
//  MovieDetail.swift
//  MDB
//
//  Created by Suruchi Chopra on 14/01/18.
//  Copyright © 2018 Suransh Chopra. All rights reserved.
//

import Foundation

class MovieDetail: Codable {
    
    let backdrop_path: String?
    let original_title: String?
    let overview: String?
    let poster_path: String?
    let release_date: String?
    
    init(backdrop_path: String?, original_title: String?, overview: String?, poster_path: String?, release_date: String?) {
        self.backdrop_path = backdrop_path
        self.original_title = original_title
        self.overview = overview
        self.poster_path  = poster_path
        self.release_date = release_date
    }
    init() {
        self.backdrop_path = nil
        self.original_title = nil
        self.overview = nil
        self.poster_path = nil
        self.release_date = nil
    }
}
