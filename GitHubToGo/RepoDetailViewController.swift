//
//  WebViewViewController.swift
//  GitHubToGo
//
//  Created by Jeff Chavez on 10/23/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import UIKit
import WebKit

class RepoDetailViewController: UIViewController {

    let webView = WKWebView()
    var selectedRepo : Repo?
    
    override func loadView() {
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: "\(self.selectedRepo!.url)")!))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}