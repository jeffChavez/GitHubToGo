//
//  NetworkController.swift
//  GitHubToGo
//
//  Created by Jeff Chavez on 10/20/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import Foundation

class NetworkController {
    
    init () {
        
    }
    
    func fetchRepo (completionHandler: (errorDescription: String?, repos: [Repo]?) -> (Void)) {
        let url = NSURL(string: "http://127.0.0.1:3000")
        let dataTask = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...204:
                    var error : NSError?
                    //top level
                    if let JSONDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? NSDictionary {
                        //second level
                        if let itemArray = JSONDictionary["items"] as? NSArray {
                            var repos = [Repo]()
                            for item in itemArray {
                                if let itemDictionary = item as? NSDictionary {
                                    var newItem = Repo(item: itemDictionary)
                                    repos.append(newItem)
                                }
                            }
                            completionHandler(errorDescription: nil, repos: repos)
                        }
                    }
                default:
                    println("bad response? \(httpResponse.statusCode)")
                }
            }
        })
        dataTask.resume()
    }
}