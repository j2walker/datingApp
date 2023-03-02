//
//  SwipingViewController.swift
//  datingApp
//
//  Created by Jack Walker on 2/25/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class SwipingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    private func validateAuth() {
        // if no one is signed in, present createOrSignInViewController
        if (FirebaseAuth.Auth.auth().currentUser == nil) {
            let vc = CreateOrSignInViewController()
            let nav = UINavigationController(rootViewController: vc)
            // must make fullscreen, otherwise presenting a VC will make it a "page" (like 95% of the screen and can swipe out of it)
            nav.modalPresentationStyle = .fullScreen
            nav.navigationBar.backgroundColor = .clear
            // no animation so you can't see transition from SwipingViewController to CreateOrSignInViewController
            present(nav, animated: false)
        }
    }
    


}
