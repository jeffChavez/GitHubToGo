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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.delegate = self
        println("123")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // This is called whenever during all navigation operations

        // Only return a custom animator for two view controller types
        if let mainViewController = fromVC as? UserSearchViewController {
            let animator = ShowImageAnimator()
            animator.origin = mainViewController.origin
            return animator
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