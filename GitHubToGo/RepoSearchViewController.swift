//
//  RepoResultsViewController.swift
//  GitHubToGo
//
//  Created by Jeff Chavez on 10/20/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import UIKit

class RepoSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    var networkController : NetworkController!
    var repos = [Repo]()
    
    @IBOutlet var tableView : UITableView!
    @IBOutlet var searchBar : UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        self.searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("REPO_SEARCH_CELL", forIndexPath: indexPath) as RepoSearchCell
        cell.repoNameLabel.text = self.repos[indexPath.row].repoName
        
        cell.repoImageView.image = nil
        var currentTag = cell.tag + 1
        cell.tag = currentTag
        
        if self.repos[indexPath.row].ownerAvatarImage != nil {
            cell.repoImageView.image = self.repos[indexPath.row].ownerAvatarImage
        } else {
            self.networkController.downloadAvatarsFromRepoSearch(self.repos[indexPath.row], completionHandler: { (image) -> (Void) in
                if let cellForImage = self.tableView.cellForRowAtIndexPath(indexPath) as? RepoSearchCell {
                        UIView.transitionWithView(cellForImage.repoImageView, duration: 0.4, options: UIViewAnimationOptions.TransitionCrossDissolve , animations: { () -> Void in
                            if cell.tag == currentTag {
                                cellForImage.repoImageView.image = image
                                cell.repoImageView.layer.cornerRadius = 3
                                cell.repoImageView.layer.masksToBounds = true
                                cell.repoImageView.layer.borderWidth = 0.5
                            }
                        }, completion: nil)
                }
            })
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let indexPath = self.tableView.indexPathForSelectedRow()
        if segue.identifier == "SHOW_SELECTED_REPO" {
            let destination = segue.destinationViewController as RepoDetailViewController
            destination.selectedRepo = self.repos[indexPath!.row]
        }
    }

    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        networkController.searchForRepos(self.searchBar.text, completionHandler: { (errorDescription, repos) -> (Void) in
            if errorDescription == nil {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.repos = repos!
                    self.tableView.reloadData()
                })
            } else {
                //alert the user something went wrong
            }
        })
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return text.validate()
    }
}
