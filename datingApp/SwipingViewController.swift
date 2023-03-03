//
//  SwipingViewController.swift
//  datingApp
//
//  Created by Jack Walker on 2/25/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import JGProgressHUD

class SwipingViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    let signOutButton : UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Sign Out", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.titleLabel?.textColor = .red
        button.titleLabel?.textAlignment = .center
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        view.addSubview(signOutButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    override func viewDidLayoutSubviews() {
        signOutButton.frame = CGRect(x: 100,
                              y: 100,
                              width: 200,
                              height: 50)
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
    
    @objc func signOut() {
        spinner.show(in: view)
        AuthHandler.shared.firebaseSignOut(completion: { [weak self] result in
            if !result {
                self?.spinner.dismiss(animated: true)
                print("error signing user out")
            } else {
                UserDefaults.standard.set(nil, forKey: "uid")
                UserDefaults.standard.set(nil, forKey: "authVerificationID")
                UserDefaults.standard.set(nil, forKey: "authVerificationCode")
                let vc = CreateOrSignInViewController()
                let nav = UINavigationController(rootViewController: vc)
                // must make fullscreen, otherwise presenting a VC will make it a "page" (like 95% of the screen and can swipe out of it)
                nav.modalPresentationStyle = .fullScreen
                nav.navigationBar.backgroundColor = .clear
                // no animation so you can't see transition from SwipingViewController to CreateOrSignInViewController
                self?.spinner.dismiss(animated: true)
                self?.present(nav, animated: true)
            }
        })
    }
}
