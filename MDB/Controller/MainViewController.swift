//
//  ViewController.swift
//  MDB
//
//  Created by Suruchi Chopra on 30/12/17.
//  Copyright © 2017 Suransh Chopra. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var MovieData =  MovieJson(results: [])
    @IBOutlet weak var tableView: UITableView!
    var actInd = UIActivityIndicatorView()
    @IBOutlet weak var listTypeCV: UICollectionView!
    let ListType: [String] = ["In Theatres","Popuar","Top Rated", "Upcoming"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ActivityIndicatory(uiView: self.view)
        fetchData(ListType: "In Theatres")
        tableView.delegate = self
        tableView.dataSource = self
        listTypeCV.delegate = self
        listTypeCV.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.black
        listTypeCV.backgroundColor = UIColor.clear
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.listTypeCV.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
        let cell = listTypeCV.cellForItem(at: IndexPath(item: 0, section: 0)) as! ListTypeCell
        cell.listType.textColor = UIColor.black
        cell.contentView.backgroundColor = UIColor.red
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListTypeCell", for: indexPath) as! ListTypeCell
        cell.listType.textColor = UIColor.red
        cell.listType.text = ListType[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor.red.cgColor
        cell.contentView.layer.masksToBounds = true;
        
        var path = UIBezierPath()
        
        if indexPath.row == 0 {
        path = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [UIRectCorner.bottomLeft,UIRectCorner.topLeft], cornerRadii: CGSize(width: 6, height: 6))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            cell.layer.mask = mask
        }
        else if indexPath.row == 3 {
            path = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [UIRectCorner.bottomRight,UIRectCorner.topRight], cornerRadii: CGSize(width: 6, height: 6))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            cell.layer.mask = mask
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ListTypeCell
        cell.listType.textColor = UIColor.black
        cell.contentView.backgroundColor = UIColor.red
        fetchData(ListType: cell.listType.text!)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ListTypeCell
        cell.listType.textColor = UIColor.black
        cell.contentView.backgroundColor = UIColor.red
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ListTypeCell
        cell.listType.textColor = UIColor.red
        cell.contentView.backgroundColor = UIColor.clear
    }
    
    func fetchData(ListType: String) -> Void {
        var temp: String
        if (ListType == "In Theatres") { temp = "now_playing" }
        else if ( ListType == "Popuar") { temp = "popular" }
        else if ( ListType == "Top Rated") { temp = "top_rated" }
        else { temp = "upcoming" }
        self.MovieData = MovieJson(results: [])
        self.tableView.reloadData()
        self.actInd.startAnimating()
        let url = appDelegate.mdbBuildUrl(pathName: "/3/movie/" + temp, methodParameters: ["api_key": Constats.Mdb.ApiKey])
        appDelegate.getJsonData(url: url) { (data) in
                self.MovieData = data
                DispatchQueue.main.async {
                    self.actInd.stopAnimating()
                    self.tableView.reloadData()
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

