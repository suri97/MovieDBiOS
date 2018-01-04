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
    let searchType = ["movie","tv"]
    var actInd = UIActivityIndicatorView()
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    func setUpViews() -> Void {
        resultLabel.isHidden = true
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
        fetchData(searchType: searchType[sender.selectedSegmentIndex], query: searchBar.text!)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieData.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! MovieCell
        cell.movieTitle.text = MovieData.results[indexPath.row].title
        
        let date = appDelegate.getYear(release_date: MovieData.results[indexPath.row].release_date)
        cell.movieYear.text = appDelegate.getYearFromDate(date: date)
        cell.movieMonth.text = appDelegate.getMonthFromDate(date: date)
        
        var genreArr = MovieData.results[indexPath.row].genre_ids
        var genreLabel = ""
        if ( genreArr.count > 0) { genreLabel = appDelegate.genre[genreArr[0]]! }
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
    
    func fetchData(searchType: String, query: String) -> Void {
        self.resultLabel.isHidden = true
        self.MovieData = MovieJson(results: [])
        self.tableView.reloadData()
        self.actInd.startAnimating()
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
    func ActivityIndicatory(uiView: UIView) {
        self.actInd.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0);
        self.actInd.center = uiView.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        uiView.addSubview(self.actInd)
    }

}
