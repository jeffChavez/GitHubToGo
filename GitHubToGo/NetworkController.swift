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
    let avatarDownloadQueue = NSOperationQueue()
    
    //get out of app and go to github
    func requestOAuthAccess () {
        let url = gitHubOAuthURL + clientID + "&" + redirectURL + "&" + scope
        println(url)
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    
    func handleOAuthURL (callbackURL: NSURL) {
        //parse through the url that is given to us by github
        let query = callbackURL.query
        let components = query?.componentsSeparatedByString("code=")
        let code = components?.last
        //construct the query string for the final POST call
        let urlQuery = clientID + "&" + clientSecret + "&" + "code=\(code!)"
        var request = NSMutableURLRequest(URL: NSURL(string: githubPostURL)!)
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
                        var tokenParsed = tokenResponse?.componentsSeparatedByString("&").first as NSString
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
    
    func createAuthenticatedSession () {
        let token = NSUserDefaults.standardUserDefaults().valueForKey("OAuthToken") as NSString
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = ["Authorization": "token \(token)"]
        self.authenticatedURLSessionConfig = NSURLSession(configuration: configuration)
    }
    
    func searchForRepos (searchTerm: String, completionHandler: (errorDescription: String?, repos: [Repo]?) -> (Void)) {
        var searchNoSpaces = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let url = NSURL(string: "https://api.github.com/search/repositories?q=\(searchNoSpaces)")
        let dataTask = self.authenticatedURLSessionConfig.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
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
    
    func searchForUsers (searchTerm: String, completionHandler: (errorDescription: String?, users: [User]?) -> (Void)) {
        var searchNoSpaces = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let url = NSURL(string: "https://api.github.com/search/users?q=\(searchNoSpaces)")
        let dataTask = self.authenticatedURLSessionConfig.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...204:
                    var error : NSError?
                    if let JSONDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? NSDictionary {
                        if let itemArray = JSONDictionary["items"] as? NSArray {
                            var users = [User]()
                            for item in itemArray {
                                if let itemDictionary = item as? NSDictionary {
                                    var newItem = User(item: itemDictionary)
                                    users.append(newItem)
                                }
                            }
                            completionHandler(errorDescription: nil, users: users)
                        }
                    }
                default:
                    println("bad response? \(httpResponse.statusCode)")
                }
            }
        })
        dataTask.resume()
    }
    
    func fetchAuthenticatedUser(completionHandler: (errorDescription: String?, authenticatedUser: AuthenticatedUser?) -> Void) {
        let url = NSURL(string: "https://api.github.com/user")
        
        let value = NSUserDefaults.standardUserDefaults().valueForKey("OAuthToken") as NSString
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = ["Authorization": "token \(value)"]
        self.authenticatedURLSessionConfig = NSURLSession(configuration: configuration)
        
        let dataTask = self.authenticatedURLSessionConfig!.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                println("something bad happened")
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...299:
                        println("good network")
                        var error : NSError?
                        let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                        if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? NSDictionary {
                            var authenticatedUser = AuthenticatedUser(jsonDictionary: jsonDictionary)
                            completionHandler(errorDescription: nil, authenticatedUser: authenticatedUser)
                        }
                    case 400...499:
                         println("This is the user's fault, code: \(httpResponse.statusCode)")
                    case 500...599:
                        println("This is ther server's fault, code: \(httpResponse.statusCode)")
                    default:
                        println("Something generally bad happened")
                    }
                }
            }
        })
        dataTask.resume()
        
    }
    
    func downloadAvatarsFromUserSearch (user: User, completionHandler: (image: UIImage) -> (Void)) {
        self.avatarDownloadQueue.addOperationWithBlock { () -> Void in
            let url = NSURL(string: user.avatarURL)
            let imageData = NSData(contentsOfURL: url!)
            let image = UIImage(data: imageData!)
            user.avatarImage = image
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(image: image!)
            })
        }
    }
    
    func downloadAvatarsFromRepoSearch (repo: Repo, completionHandler: (image:UIImage) -> (Void)) {
        self.avatarDownloadQueue.addOperationWithBlock { () -> Void in
            let url = NSURL(string: repo.ownerAvatarURL)
            let imageData = NSData(contentsOfURL: url!)
            let image = UIImage(data: imageData!)
            repo.ownerAvatarImage = image
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(image: image!)
            })
        }
    }
}