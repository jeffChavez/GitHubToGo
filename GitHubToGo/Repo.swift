//
//  SearchResult.swift
//  GitHubToGo
//
//  Created by Jeff Chavez on 10/20/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import UIKit

class Repo {
    
    var repoName : String
    var url : String
    var login : String
    var avatar_url : String
    var avatarImage : UIImage?
    
    init (item: NSDictionary) {
        self.repoName = item["name"] as String
        self.url = item["html_url"] as String
        let owner = item["owner"] as NSDictionary
        self.login = owner["login"] as String
        self.avatar_url = owner["avatar_url"] as String
    }
}