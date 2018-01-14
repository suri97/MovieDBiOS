//
//  MovieDetailViewController.swift
//  MDB
//
//  Created by Suruchi Chopra on 14/01/18.
//  Copyright © 2018 Suransh Chopra. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    var MovieID: Int64?
    let applicationDelegate = UIApplication.shared.delegate as! AppDelegate
    var Movie = MovieDetail()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        guard let id = self.MovieID else { return }
        fetchData(id: id)
    }
    
    func fetchData(id: Int64) {
        let url = applicationDelegate.mdbBuildUrl(pathName: "/3/movie/\(id)", methodParameters: ["api_key" : Constats.Mdb.ApiKey])
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            if (err != nil) {
                print (err!)
                return
            }
            guard let data = data else {return}
            do {
                self.Movie = try JSONDecoder().decode(MovieDetail.self, from: data)
            } catch let error {
                print (error)
            }
            }.resume()
    }
    
}
