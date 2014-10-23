//
//  UserSearchCell.swift
//  GitHubToGo
//
//  Created by Jeff Chavez on 10/22/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import UIKit

class UserSearchCell : UICollectionViewCell {
    
    @IBOutlet var userImageView : UIImageView!
    @IBOutlet var usernameLabel : UILabel!
    
    override func prepareForReuse() {
        self.userImageView.image = nil
    }
}