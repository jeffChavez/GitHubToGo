//
//  RootViewController.swift
//  GitHubToGo
//
//  Created by Jeff Chavez on 10/20/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController, UINavigationControllerDelegate {
    
    
    var window : UIWindow?
    var networkController : NetworkController!
    var authenticatedUser : AuthenticatedUser?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.delegate = self

        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        }
    
    override func viewDidAppear(animated: Bool) {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "SHOW_MY_PROFILE" {
            let destination = segue.destinationViewController as MyProfileViewController
            destination.authenticatedUser = self.authenticatedUser
        }
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // This is called whenever during all navigation operations

        // Only return a custom animator for two view controller types
        if let mainViewController = fromVC as? UserSearchViewController {
            if let toViewController = toVC as? UserDetailViewController {
                let animator = ShowImageAnimator()
                animator.origin = mainViewController.origin
                return animator
            }
        }
        else if let imageViewController = fromVC as? UserDetailViewController {
            let animator = HideImageAnimator()
            animator.origin = imageViewController.reverseOrigin
            return animator
        }
        // All other types use default transition
        return nil
    }
}