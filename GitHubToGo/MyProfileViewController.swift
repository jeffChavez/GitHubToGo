//
//  MyProfileViewController.swift
//  GitHubToGo
//
//  Created by Jeff Chavez on 10/24/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {

    var networkController : NetworkController!
    var authenticatedUser : AuthenticatedUser?
    
    @IBOutlet var imageView : UIImageView!
    @IBOutlet var usernameLabel : UILabel!
    @IBOutlet var publicRepoCountLabel : UILabel!
    @IBOutlet var bioLabel : UILabel!
    @IBOutlet var privateRepoCountLabel : UILabel!
    @IBOutlet var hireableBox : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        
        self.imageView.image = UIImage(named: "GitHub-Mark")
        self.networkController.fetchAuthenticatedUser { (errorDescription, authenticatedUser) -> Void in
            if errorDescription == nil {
                self.authenticatedUser = authenticatedUser!
                println("authentication completed")
            } else {
                println("authentication error")
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {

        self.usernameLabel.text = self.authenticatedUser?.username
        self.publicRepoCountLabel.text = self.authenticatedUser?.publicRepos.description
        self.bioLabel.text = self.authenticatedUser?.bio
        self.privateRepoCountLabel.text = self.authenticatedUser?.privateRepos.description
        if self.authenticatedUser?.hireable == true {
            self.hireableBox.backgroundColor = UIColor.greenColor()
        } else {
            self.hireableBox.backgroundColor = UIColor.redColor()
        }
        if self.authenticatedUser?.avatarImage != nil {
            self.imageView.image = self.authenticatedUser?.avatarImage
        } else {
            self.networkController.downloadAvatarsFromUserSearch(self.authenticatedUser!, completionHandler: { (image) -> (Void) in
                UIView.transitionWithView(self.imageView, duration: 0.4, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                    self.imageView.image = image
                    self.imageView.layer.cornerRadius = 3
                    self.imageView.layer.masksToBounds = true
                    self.imageView.layer.borderWidth = 0.5
                    }, completion: nil)
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
