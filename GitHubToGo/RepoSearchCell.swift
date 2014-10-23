//
//  RepoSearchCell.swift
//  GitHubToGo
//
//  Created by Jeff Chavez on 10/23/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import UIKit

class RepoSearchCell : UITableViewCell {
    
    @IBOutlet var repoImageView : UIImageView!
    @IBOutlet var repoNameLabel : UILabel!
    
    override func prepareForReuse() {
        self.repoImageView.image = nil
    }
}