//
//  UserDetailViewController.swift
//  GitHubToGo
//
//  Created by Jeff Chavez on 10/22/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet var imageView : UIImageView!
    @IBOutlet var usernameLabel : UILabel?
    
    var selectedUser : User?
    
    var reverseOrigin: CGRect?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.imageView.image = selectedUser?.avatarImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
