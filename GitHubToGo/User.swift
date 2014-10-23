//
//  SearchResult.swift
//  GitHubToGo
//
//  Created by Jeff Chavez on 10/20/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import UIKit

class User {
    
    var avatar_url : String
    var avatarImage : UIImage?
    var username : String
    
    init (item: NSDictionary) {
        self.avatar_url = item["avatar_url"] as String
        self.username = item["login"] as String
    }
}