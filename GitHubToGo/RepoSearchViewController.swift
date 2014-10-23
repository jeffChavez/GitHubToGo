//
//  RepoResultsViewController.swift
//  GitHubToGo
//
//  Created by Jeff Chavez on 10/20/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import UIKit

class RepoSearchViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {

    var networkController : NetworkController!
    var repos = [Repo]()
    
    @IBOutlet var tableView : UITableView!
    @IBOutlet var searchBar : UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        
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
        return self.repos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SHOW_RESULTS_CELL", forIndexPath: indexPath) as UITableViewCell
        let repos = self.repos[indexPath.row]
        cell.textLabel.text = repos.repoName
        return cell
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
}
