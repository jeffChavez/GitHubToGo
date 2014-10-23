//
//  UserSearchViewController.swift
//  GitHubToGo
//
//  Created by Jeff Chavez on 10/22/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import UIKit

class UserSearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var networkController : NetworkController!
    var users = [User]()
    var origin : CGRect?
    
    @IBOutlet var collectionView : UICollectionView!
    @IBOutlet var searchBar : UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        
        self.searchBar.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        networkController.searchForUsers(self.searchBar.text, completionHandler: { (errorDescription, users) -> (Void) in
            if errorDescription == nil {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.users = users!
                    self.collectionView.reloadData()
                })
            } else {
                //alert the user something went wrong
            }
        })
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("USER_SEARCH_CELL", forIndexPath: indexPath) as UserSearchCell
        cell.usernameLabel.text = self.users[indexPath.row].username
        if self.users[indexPath.row].avatarImage != nil {
            cell.imageView.image = self.users[indexPath.row].avatarImage
        } else {
            self.networkController.downloadAvatarsForProfiles(self.users[indexPath.row], completionHandler: { (image) -> (Void) in
                let cellForImage = self.collectionView.cellForItemAtIndexPath(indexPath) as UserSearchCell
                cellForImage.imageView.image = image
                cell.imageView.layer.cornerRadius = 3
                cell.imageView.layer.masksToBounds = true
                cell.imageView.layer.borderWidth = 0.5
            })
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // Grab the attributes of the tapped upon cell
        let attributes = collectionView.layoutAttributesForItemAtIndexPath(indexPath)
        
        // Grab the onscreen rectangle of the tapped upon cell, relative to the collection view
        let origin = self.view.convertRect(attributes!.frame, fromView: collectionView)
        
        // Save our starting location as the tapped upon cells frame
        self.origin = origin
        
        // Find tapped image, initialize next view controller
        let user = self.users[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewControllerWithIdentifier("USER_DETAIL_VC") as UserDetailViewController
        
        // Set image and reverseOrigin properties on next view controller
        newVC.selectedUser = user
        newVC.reverseOrigin = self.origin!
        
        // Trigger a normal push animations; let navigation controller take over.
        self.navigationController?.pushViewController(newVC, animated: true)

    }
}
