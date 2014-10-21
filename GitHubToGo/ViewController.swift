//
//  ViewController.swift
//  GitHubToGo
//
//  Created by Jeff Chavez on 10/20/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var networkController : NetworkController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        
        //fast load, thanks to will richman
        dispatch_after(1, dispatch_get_main_queue(), {
            self.networkController.requestOAuthAccess()
        })
        // Do any additional setup after loading the view, typically from a nib.
    }
}   