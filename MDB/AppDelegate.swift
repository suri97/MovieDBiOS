//
//  AppDelegate.swift
//  MDB
//
//  Created by Suruchi Chopra on 30/12/17.
//  Copyright © 2017 Suransh Chopra. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var genre = [Int:String]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        getGenre()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension AppDelegate {
    
    func mdbBuildUrl(pathName: String, methodParameters: [String:String]) -> URL {
        var componentUrl = URLComponents()
        componentUrl.scheme = Constats.Mdb.Scheme
        componentUrl.host = Constats.Mdb.Host
        componentUrl.path = pathName
        componentUrl.queryItems = [URLQueryItem]()
        for (key,value) in methodParameters {
            componentUrl.queryItems?.append(URLQueryItem(name: key, value: "\(value)"))
        }
        return componentUrl.url!
    }
    
    func getJsonData(url: URL, completion: @escaping (_ json: MovieJson) -> Void ) {
        
        var MovieData = MovieJson(results: [])
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            if let data = data {
                do {
                    MovieData = try JSONDecoder().decode(MovieJson.self, from: data)
                    completion(MovieData)
                } catch let error {
                    print(error)
                    completion(MovieData)
                }
            }
        }.resume()
    }
    
    func getTVJsonData(url: URL, completion: @escaping (_ json: TVJson) -> Void ) {
        
        var TVData = TVJson(results: [])
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            if let data = data {
                do {
                    TVData = try JSONDecoder().decode(TVJson.self, from: data)
                    completion(TVData)
                } catch let error {
                    print(error)
                    completion(TVData)
                }
            }
            }.resume()
    }
    
    func getYear(release_date: String) -> Date {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let date = dateFormat.date(from: release_date)
        return date!
    }
    
    func getMonthFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from:date)
    }
    
    func getYearFromDate(date: Date) -> String {
        let year = Calendar.current.component(Calendar.Component.year, from: date)
        return String(year)
    }
    
    func getGenre() -> Void {
        let url = mdbBuildUrl(pathName: "/3/genre/movie/list", methodParameters: ["api_key" : Constats.Mdb.ApiKey])
        struct genreDef: Codable {
            let id: Int
            let name: String
        }
        struct jsonData:Codable {
            var genres: [genreDef]
        }
        
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            if let data = data {
                do {
                    let genreArr = try JSONDecoder().decode(jsonData.self, from: data)
                    for elem in genreArr.genres {
                        self.genre[elem.id] = elem.name
                    }
                } catch let error {
                    print(error)
                }
            }
        }.resume()
    }
    
}

