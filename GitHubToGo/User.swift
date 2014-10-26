//
//  SearchResult.swift
//  GitHubToGo
//
//  Created by Jeff Chavez on 10/20/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import UIKit

class User {
    
    var avatarURL : String
    var avatarImage : UIImage?
    var username : String
    
    init (item: NSDictionary) {
        self.avatarURL = item["avatar_url"] as String
        self.username = item["login"] as String
    }
}

class AuthenticatedUser : User {
    
    var bio : String?
    var hireable : Bool
    var publicRepos : Int
    var privateRepos : Int
    
    init (jsonDictionary: NSDictionary) {
        self.bio = jsonDictionary["bio"] as? String
        if self.bio == nil {
            self.bio = "Bio Unavailable"
        }
        self.hireable = jsonDictionary["hireable"] as Bool
        self.publicRepos = jsonDictionary["public_repos"] as Int
        let plan = jsonDictionary["plan"] as NSDictionary
        self.privateRepos = plan["private_repos"] as Int
        super.init(item: jsonDictionary)
    }
}