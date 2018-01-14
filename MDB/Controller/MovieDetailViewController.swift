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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        guard let id = self.MovieID else { return }
        print (id)
    }
    
}
