//
//  ViewController.swift
//  MDB
//
//  Created by Suruchi Chopra on 30/12/17.
//  Copyright © 2017 Suransh Chopra. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var MovieData =  MovieJson(results: [])
    @IBOutlet weak var tableView: UITableView!
    var actInd = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ActivityIndicatory(uiView: self.view)
        fetchData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.black
        UIApplication.shared.statusBarStyle = .lightContent
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieData.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        cell.movieTitle.text = MovieData.results[indexPath.row].title
        
        let date = appDelegate.getYear(release_date: MovieData.results[indexPath.row].release_date)
        cell.movieYear.text = appDelegate.getYearFromDate(date: date)
        cell.movieMonth.text = appDelegate.getMonthFromDate(date: date)
        
        var genreArr = MovieData.results[indexPath.row].genre_ids
        var genreLabel: String = appDelegate.genre[genreArr[0]]!
        if genreArr.count > 1 {
            for i in 1..<genreArr.count {
                genreLabel += ", \(appDelegate.genre[ genreArr[i] ]!)"
            }
        }
        cell.genre.text = genreLabel
        
        if let imageURL = URL(string: Constats.Mdb.baseImgUrl + "/w92" + MovieData.results[indexPath.row].poster_path) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.poster.image = image
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func fetchData() -> Void {
        self.actInd.startAnimating()
        let url = appDelegate.mdbBuildUrl(pathName: "/3/movie/now_playing", methodParameters: ["api_key": Constats.Mdb.ApiKey])
        appDelegate.getJsonData(url: url) { (data) in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                self.MovieData = data
                DispatchQueue.main.async {
                    self.actInd.stopAnimating()
                    self.tableView.reloadData()
                }
            })
        }
    }
    func ActivityIndicatory(uiView: UIView) {
        self.actInd.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0);
        self.actInd.center = uiView.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        uiView.addSubview(self.actInd)
    }
    
}

