//
//  CreateOrSignInViewController.swift
//  datingApp
//
//  Created by Jack Walker on 2/28/23.
//

import UIKit

class CreateOrSignInViewController: UIViewController {
    
    var logoView : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "tinderLogoWhite") ?? UIImage(systemName: "questionmark.dashed")
        image.frame.size.width = 250
        image.frame.size.height = 180
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let createButton : UIButton = {
        var button = UIButton()
        button.backgroundColor = .white
        button.setTitle("CREATE ACCOUNT", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        return button
    }()
    
    let signInButton : UIButton = {
        var button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("SIGN IN", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        return button
    }()
    
    let troubleButton : UIButton = {
        var button = UIButton()
        button.setTitle("Trouble signing in?", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        return button
    }()
    
    let termsText : UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.text = "By tapping Create Account or Sign In, you agree to out Terms."
        + " Learn how we process your data in our Privacy Policy and Cookies Policy."
        textView.textColor = .white
        textView.font = .systemFont(ofSize: 13, weight: .semibold)
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.isSelectable = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.addSublayer(createGradient())
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        troubleButton.addTarget(self, action: #selector(troubleButtonTapped), for: .touchUpInside)
        view.addSubview(logoView)
        view.addSubview(termsText)
        view.addSubview(createButton)
        view.addSubview(signInButton)
        view.addSubview(troubleButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logoView.frame = CGRect(x: (view.width-250)/2,
                                y: (view.height-180)/2,
                                width: 250,
                                height: 180)
        
        termsText.frame = CGRect(x: 30,
                                 y: logoView.bottom + 50,
                                 width: view.width - 60,
                                 height: 70)
        
        createButton.frame = CGRect(x: 30,
                                    y: termsText.bottom + 10,
                                    width: view.width - 60,
                                    height: 50)
        signInButton.frame = CGRect(x: 30,
                                    y: createButton.bottom + 15,
                                    width: view.width - 60,
                                    height: 50)
        troubleButton.frame = CGRect(x: 60,
                                     y: signInButton.bottom + 15,
                                     width: view.width - 120,
                                     height: 30)
    }
    
    func createGradient() -> CAGradientLayer {
        // Setting up the gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        // Make the array of colors to make the gradient - First color -> Last color = Top -> Bottom gradient pattern
        gradientLayer.colors = [UIColor(named: "Base Orange")?.cgColor ?? UIColor.black.cgColor,
                                UIColor(named: "Pink Orange")?.cgColor ?? UIColor.black.cgColor,
                                UIColor(named: "Base Pink")?.cgColor ?? UIColor.black.cgColor]
        gradientLayer.shouldRasterize = true
        return gradientLayer
    }
    
    @objc func createButtonTapped() {
        let vc = CreateViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func signInButtonTapped() {
        print("sign In")
    }
    
    @objc func troubleButtonTapped() {
        print("trouble")
    }
    

}
