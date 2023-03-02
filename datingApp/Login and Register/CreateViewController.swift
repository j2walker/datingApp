//
//  RegisterViewController.swift
//  datingApp
//
//  Created by Jack Walker on 2/25/23.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class CreateViewController: UIViewController, UITextFieldDelegate {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    var bottomLine : CALayer = {
        let line = CALayer()
        line.backgroundColor = UIColor.darkGray.cgColor
        return line
    }()
    
    let nextButton : UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        button.layer.shadowRadius = 5.0
        button.layer.shadowOpacity = 0.3
        return button
    }()
    
    let canGetNumber : UITextView = {
        let textView = UITextView()
        textView.isSelectable = false
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.text = "Can we get your number?"
        textView.font = .systemFont(ofSize: 27, weight: .semibold)
        textView.textColor = .black
        textView.textAlignment = .center
        return textView
    }()
    
    let plusSign : UITextView = {
        let textView = UITextView()
        textView.text = "+"
        textView.font = .systemFont(ofSize: 20, weight: .semibold)
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let countryCode : UITextField = {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.text = "1"
        field.font = .systemFont(ofSize: 20, weight: .semibold)
        return field
    }()
    
    let backButton : UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
        let image = UIImage(systemName: "chevron.backward", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = .darkGray
        return button
    }()
    
    let numberInputField : UITextField = {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.borderStyle = .none
        field.font = .systemFont(ofSize: 20, weight: .semibold)
        return field
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        view.backgroundColor = .white
        view.addSubview(canGetNumber)
        view.addSubview(backButton)
        view.addSubview(numberInputField)
        view.addSubview(countryCode)
        view.addSubview(plusSign)
        view.layer.addSublayer(bottomLine)
        numberInputField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.frame = CGRect(x: 10,
                                  y: 60,
                                  width: 40,
                                  height: 40)
        canGetNumber.frame = CGRect(x: 30,
                                    y: backButton.bottom + 30,
                                    width: view.width - 60,
                                    height: 40)
        plusSign.frame = CGRect(x: 30,
                                y: canGetNumber.bottom + 20,
                                width: 20,
                                height: 30)
        countryCode.frame = CGRect(x: plusSign.right + 5,
                                   y: canGetNumber.bottom + 20,
                                   width: 35,
                                   height: 30)
        numberInputField.frame = CGRect(x: countryCode.right + 10,
                                        y: canGetNumber.bottom + 20,
                                        width: view.width-90,
                                        height: 30)
        bottomLine.frame = CGRect(x: countryCode.right + 10,
                                  y: numberInputField.bottom + 1,
                                  width: view.width-90,
                                  height: 2)
        
        nextButton.frame = CGRect(x: 30,
                              y: numberInputField.bottom + 11,
                              width: view.width-60,
                              height: 50)
        nextButton.layer.insertSublayer(createGradient(), at: 0)
        
        view.addSubview(nextButton)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = 10
        if (textField == countryCode) {
            maxLength = 3
        }
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
    }
    
    
    @objc func dismissSelf() {
        dismiss(animated: true)
    }
    
    @objc func nextButtonTapped() {
        spinner.show(in: view)
        guard let number = numberInputField.text, let country = countryCode.text else {
            spinner.dismiss()
            return
        }
        PhoneAuthProvider.provider().verifyPhoneNumber("+"+country+number, uiDelegate: nil) { [weak self] verificationID, error in
            if let error = error {
                print("error verifying phone number with \(error)")
                self?.spinner.dismiss()
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            self?.spinner.dismiss()
            let vc = PhoneAuthViewController()
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true)
        }
    }
    
    func createGradient() -> CAGradientLayer {
        // Setting up the gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = nextButton.bounds
        gradientLayer.cornerRadius = nextButton.layer.cornerRadius
        gradientLayer.shadowColor = nextButton.layer.shadowColor
        gradientLayer.shadowOffset = nextButton.layer.shadowOffset
        gradientLayer.shadowRadius = nextButton.layer.shadowRadius
        gradientLayer.shadowOpacity = nextButton.layer.shadowOpacity
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        // Make the array of colors to make the gradient - First color -> Last color = Top -> Bottom gradient pattern
        gradientLayer.colors = [UIColor(named: "Base Orange")?.cgColor ?? UIColor.black.cgColor,
                                UIColor(named: "Pink Orange")?.cgColor ?? UIColor.black.cgColor,
                                UIColor(named: "Base Pink")?.cgColor ?? UIColor.black.cgColor]
        gradientLayer.shouldRasterize = true
        return gradientLayer
    }
    
    


}
