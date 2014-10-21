//
//  NetworkController.swift
//  GitHubToGo
//
//  Created by Jeff Chavez on 10/20/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import UIKit

class NetworkController {
    
    let clientID = "client_id=64aebcd7ec7eec9ca76f"
    let clientSecret = "client_secret=5a1c922f94dcf6aacfc9b9f30bd01065a91d2dc7"
    let gitHubOAuthURL = "https://github.com/login/oauth/authorize?"
    let scope = "scope=user,repo"
    let redirectURL = "redirect_uri=githubtogo://jeffsapp"
    let githubPostURL = "https://github.com/login/oauth/access_token"
    
    var authenticatedURLSessionConfig : NSURLSession!
    var token : String!
    
    //get out of app and go to github
    func requestOAuthAccess () {
        let url = gitHubOAuthURL + clientID + "&" + redirectURL + "&" + scope
        UIApplication.sharedApplication().openURL(NSURL(string: url))
    }
    
    func handleOAuthURL (callbackURL: NSURL) {
        //parse through the url that is given to us by github
        let query = callbackURL.query
        let components = query?.componentsSeparatedByString("code=")
        let code = components?.last
        //construct the query string for the final POST call
        let urlQuery = clientID + "&" + clientSecret + "&" + "code=\(code!)"
        var request = NSMutableURLRequest(URL: NSURL(string: githubPostURL))
        request.HTTPMethod = "POST"
        //turns string into data
        var postData = urlQuery.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        let length = postData?.length
        request.setValue("\(length)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                println(error.localizedDescription)
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...204:
                        var tokenResponse = NSString(data: data, encoding: NSASCIIStringEncoding)
                        //parse through the response and get auth token and authorization
                        var tokenParsed = tokenResponse.componentsSeparatedByString("&").first as NSString
                        tokenParsed = tokenParsed.componentsSeparatedByString("access_token=").last as NSString
                        println(tokenParsed)
                        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
                        configuration.HTTPAdditionalHeaders = ["Authorization": "token \(tokenParsed)"]
                        self.authenticatedURLSessionConfig = NSURLSession(configuration: configuration)
                        NSUserDefaults.standardUserDefaults().setValue(tokenParsed, forKey: "OAuthToken")
                        NSUserDefaults.standardUserDefaults().synchronize()
                    default:
                        println("default case on status code")
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    init () {
        
    }
    func fetchRepo (usernameSearch: String, completionHandler: (errorDescription: String?, repos: [Repo]?) -> (Void)) {
        let url = NSURL(string: "https://api.github.com/search/repositories?q=\(usernameSearch)")
        let dataTask = self.authenticatedURLSessionConfig.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...204:
                    var error : NSError?
                    if let JSONDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? NSDictionary {
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
    
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    func fetchDummyJSON (completionHandler: (errorDescription: String?, repos: [Repo]?) -> (Void)) {
//        if let path = NSBundle.mainBundle().pathForResource("dummy", ofType: "json") {
//            let data = NSData(contentsOfFile: path)
//            var error : NSError?
//            if let JSONArray = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? NSArray {
//                if let JSONDictionary = JSONArray[0] as? NSDictionary {
//                    if let friendsDictionary = JSONDictionary["friends"] as? NSDictionary {
//                        if let friendsArray = friendsDictionary[[0]] as? NSArray {
//                            if let friendsArrayOfDictionaries = friendsArray[0] as? NSDictionary {
//                                if let id = friendsArrayOfDictionaries["id"] as? NSDictionary {
//                                    println(id)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }

    func fetchDummyJSON (completionHandler: (errorDescription: String?, repos: [Repo]?) -> (Void)) {
        if let path = NSBundle.mainBundle().pathForResource("dummy", ofType: "json") {
            let data = NSData(contentsOfFile: path)
            var error: NSError?
            if let JSONArray = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? NSArray {
                var repos = [Repo]()
                for JSONDictionary in JSONArray {
                    if let repoDictionary = JSONDictionary as? NSDictionary {
                        var parsedRepos = Repo(item: repoDictionary)
                        repos.append(parsedRepos)
                    }
                }
                completionHandler(errorDescription: nil, repos: repos)
            }
        }
    }
}