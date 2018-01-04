//
//  SearchViewController.swift
//  MDB
//
//  Created by Suruchi Chopra on 02/01/18.
//  Copyright © 2018 Suransh Chopra. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segControl: UISegmentedControl!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var MovieData =  MovieJson(results: [])
    var TVData =  TVJson(results: [])
    let searchType = ["movie","tv"]
    var actInd = UIActivityIndicatorView()
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    func setUpViews() -> Void {
        ActivityIndicatory(uiView: self.view)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.black
        UIApplication.shared.statusBarStyle = .lightContent
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchData(searchType: searchType[segControl.selectedSegmentIndex], query: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    @IBAction func handleSelection(_ sender: UISegmentedControl) {
        if searchBar.text != "" {
            fetchData(searchType: searchType[sender.selectedSegmentIndex], query: searchBar.text!)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchType[segControl.selectedSegmentIndex] == "movie" {
            return MovieData.results.count
        }
        return TVData.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! MovieCell
        
        if searchType[segControl.selectedSegmentIndex] == "movie" {
            cell.movieTitle.text = MovieData.results[indexPath.row].title
        }
        else {
            cell.movieTitle.text = TVData.results[indexPath.row].original_name
        }
        if searchType[segControl.selectedSegmentIndex] == "movie" {
            if MovieData.results[indexPath.row].release_date != "" {
                let date = appDelegate.getYear(release_date: MovieData.results[indexPath.row].release_date)
                cell.movieYear.text = appDelegate.getYearFromDate(date: date)
                cell.movieMonth.text = appDelegate.getMonthFromDate(date: date)
            }
        }
        else {
            if TVData.results[indexPath.row].first_air_date != "" {
                let date = appDelegate.getYear(release_date: TVData.results[indexPath.row].first_air_date)
                cell.movieYear.text = appDelegate.getYearFromDate(date: date)
                cell.movieMonth.text = appDelegate.getMonthFromDate(date: date)
            }
        }
        var genreArr: [Int]
        if searchType[segControl.selectedSegmentIndex] == "movie" { genreArr = MovieData.results[indexPath.row].genre_ids }
        else { genreArr = TVData.results[indexPath.row].genre_ids  }
        var genreLabel = ""
        if ( genreArr.count > 0) {
            if let label = appDelegate.genre[genreArr[0]] {
                genreLabel = label
            }
        }
        if genreArr.count > 1 {
            for i in 1..<genreArr.count {
                if let label = appDelegate.genre[ genreArr[i] ] {
                    genreLabel += ", \(label)"
                }
            }
        }
        cell.genre.text = genreLabel
        var tempUrl: String = ""
        if searchType[segControl.selectedSegmentIndex] == "movie" {
            if let poster = MovieData.results[indexPath.row].poster_path {
                tempUrl = poster
            }
        }
        else {
            if let poster = TVData.results[indexPath.row].poster_path {
                tempUrl = poster
            }
        }
        if let imageURL = URL(string: Constats.Mdb.baseImgUrl + "/w92" + tempUrl) {
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
    
    func fetchData(searchType: String, query: String) -> Void {
        self.resultLabel.isHidden = true
        self.MovieData = MovieJson(results: [])
        self.TVData = TVJson(results: [])
        self.tableView.reloadData()
        self.actInd.startAnimating()
        if searchType == "movie" {
            let url = appDelegate.mdbBuildUrl(pathName: "/3/search/" + searchType, methodParameters: ["api_key": Constats.Mdb.ApiKey,"query": query])
            appDelegate.getJsonData(url: url) { (data) in
                self.MovieData = data
                DispatchQueue.main.async {
                    self.actInd.stopAnimating()
                    if self.MovieData.results.count > 0 {
                        self.tableView.reloadData()
                    }
                    else {
                        self.resultLabel.isHidden = false
                    }
                }
            }
        }
        else {
            let url = appDelegate.mdbBuildUrl(pathName: "/3/search/" + searchType, methodParameters: ["api_key": Constats.Mdb.ApiKey,"query": query])
            appDelegate.getTVJsonData(url: url) { (data) in
                self.TVData = data
                DispatchQueue.main.async {
                    self.actInd.stopAnimating()
                    if self.TVData.results.count > 0 {
                        self.tableView.reloadData()
                    }
                    else {
                        self.resultLabel.isHidden = false
                    }
                }
            }
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
