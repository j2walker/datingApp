//
//  PhoneAuthViewController.swift
//  datingApp
//
//  Created by Jack Walker on 3/1/23.
//

import UIKit
import JGProgressHUD

protocol fieldDelegate {
    func textFieldDidChange(textField: UITextField)
}

class PhoneAuthViewController: UIViewController, UITextFieldDelegate, fieldDelegate {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var numTextFields : [numberTextField] = []
    private var bottomLines : [CALayer] = []
    
    let pleaseEnter : UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.isSelectable = false
        view.isScrollEnabled = false
        view.text = "Enter your code"
        view.font = .systemFont(ofSize: 27, weight: .semibold)
        view.textColor = .black
        view.backgroundColor = .white
        view.textAlignment = .center
        return view
    }()
    
    let backButton : UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
        let image = UIImage(systemName: "chevron.backward", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = .darkGray
        return button
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        backButton.addTarget(self, action: #selector(backButtonHit), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonHit), for: .touchUpInside)
        
        for _ in 0...5 {
            let field = numberTextField()
            let bottomLine = CALayer()
            field.thisDelegate = self
            field.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
            field.keyboardType = .numberPad
            field.backgroundColor = .white
            field.textColor = .black
            field.textAlignment = .center
            field.font = .systemFont(ofSize: 25)
            bottomLine.backgroundColor = UIColor.darkGray.cgColor
            numTextFields.append(field)
            bottomLines.append(bottomLine)
            view.addSubview(field)
            view.layer.addSublayer(bottomLine)
        }
        numTextFields[0].becomeFirstResponder()
        view.addSubview(pleaseEnter)
        view.addSubview(backButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let numWidthSpacing : CGFloat = ((50*6) + (10*5))
        for i in 0...5 {
            let field = numTextFields[i]
            let line = bottomLines[i]
            let prevX = (i != 0) ? numTextFields[i-1].right : ((view.width - numWidthSpacing)/2 - 10)
            field.frame = CGRect(x: 10 + prevX, y: 200, width: 50, height: 50)
            line.frame = CGRect(x: 10 + prevX, y: 251, width: 50, height: 2)
        }
        
        pleaseEnter.frame = CGRect(x: (view.width-250) / 2,
                                   y: 100,
                                   width: 250,
                                   height: 50)
        backButton.frame = CGRect(x: 10,
                                  y: 60,
                                  width: 40,
                                  height: 40)
        nextButton.frame = CGRect(x: 30,
                              y: numTextFields[2].bottom + 50,
                              width: view.width-60,
                              height: 50)
        nextButton.layer.insertSublayer(createGradient(), at: 0)
        view.addSubview(nextButton)
        
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        let text = textField.text
        print("in me :)")
        
        if  text?.count == 1 {
            switch textField {
            case numTextFields[0]:
                numTextFields[1].becomeFirstResponder()
            case numTextFields[1]:
                numTextFields[2].becomeFirstResponder()
            case numTextFields[2]:
                numTextFields[3].becomeFirstResponder()
            case numTextFields[3]:
                numTextFields[4].becomeFirstResponder()
            case numTextFields[4]:
                numTextFields[5].becomeFirstResponder()
            case numTextFields[5]:
                numTextFields[5].resignFirstResponder()
                self.view.endEditing(true)
                
            default:
                break
            }
        }
        
        if  text?.count == 0 {
            switch textField {
            case numTextFields[0]:
                numTextFields[0].becomeFirstResponder()
                numTextFields[0].text = ""
            case numTextFields[1]:
                numTextFields[0].becomeFirstResponder()
                numTextFields[0].text = ""
            case numTextFields[2]:
                numTextFields[1].becomeFirstResponder()
                numTextFields[1].text = ""
            case numTextFields[3]:
                numTextFields[2].becomeFirstResponder()
                numTextFields[2].text = ""
            case numTextFields[4]:
                numTextFields[3].becomeFirstResponder()
                numTextFields[3].text = ""
            case numTextFields[5]:
                numTextFields[4].becomeFirstResponder()
                numTextFields[4].text = ""
            default:
                break
            }
        }
        else{
            
        }
    }
    
    func codeFilled() {
        var finalCode = ""
        for i in 0...5 {
            if let digit = numTextFields[i].text {
                finalCode += digit
            }
        }
        
        UserDefaults.standard.set(finalCode, forKey: "authVerificationCode")
        guard let authVerificationID = UserDefaults.standard.value(forKey: "authVerificationID") as? String else {
            return
        }
        AuthHandler.shared.firebseSignIn(with: authVerificationID, verificationCode: finalCode, completion: { [weak self] result in
            if (result) {
                DispatchQueue.main.async { [weak self] in
                    for i in 0...5 {
                        self?.numTextFields[i].textColor = .green
                    }
                }
                self?.spinner.dismiss(animated: true)
                self?.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            } else {
                
                // HANDLE WHEN CODE IS WRONG
                DispatchQueue.main.async {
                    for i in 0...5 {
                        self?.numTextFields[i].textColor = .red
                    }
                    self?.spinner.dismiss(animated: true)
                }
            }
        })
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
    
    @objc func backButtonHit() {
        dismiss(animated: true)
    }
    
    @objc func nextButtonHit() {
        self.spinner.show(in: view)
        codeFilled()
    }
    
}



class numberTextField : UITextField {
    var thisDelegate: fieldDelegate?
    override func deleteBackward() {
        super.deleteBackward()
        thisDelegate?.textFieldDidChange(textField: self)
    }
}
