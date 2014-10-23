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
        
        if let value = NSUserDefaults.standardUserDefaults().valueForKey("OAuthToken") as? String {
            println("value\(value)")
            self.networkController.createAuthenticatedSession()
        } else {
            var alertController = UIAlertController(title: "Authentication Required", message: "You must sign into your account before continuing. Redirect to Github.com?", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                dispatch_after(1, dispatch_get_main_queue(), {
                    self.networkController.requestOAuthAccess()
                })
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}