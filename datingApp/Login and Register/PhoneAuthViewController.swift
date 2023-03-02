//
//  PhoneAuthViewController.swift
//  datingApp
//
//  Created by Jack Walker on 3/1/23.
//

import UIKit

protocol fieldDelegate {
    func textFieldDidChange(textField: UITextField)
}

class PhoneAuthViewController: UIViewController, UITextFieldDelegate, fieldDelegate {
    
    private var numTextFields : [numberTextField] = []
    private var bottomLines : [CALayer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for i in 0...5 {
            let field = numTextFields[i]
            let line = bottomLines[i]
            let prevX = (i != 0) ? numTextFields[i-1].right : 20
            field.frame = CGRect(x: 10 + prevX, y: 100, width: 50, height: 50)
            line.frame = CGRect(x: 10 + prevX, y: 151, width: 50, height: 2)
        }
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
                codeFilled()
            default:
                break
            }
        }
        
        if  text?.count == 0 {
            switch textField {
            case numTextFields[0]:
                numTextFields[0].becomeFirstResponder()
            case numTextFields[1]:
                numTextFields[0].becomeFirstResponder()
            case numTextFields[2]:
                numTextFields[1].becomeFirstResponder()
            case numTextFields[3]:
                numTextFields[2].becomeFirstResponder()
            case numTextFields[4]:
                numTextFields[3].becomeFirstResponder()
            case numTextFields[5]:
                numTextFields[4].becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
    
    
    
    func codeFilled() {
        
    }
}

class numberTextField : UITextField {
    var thisDelegate: fieldDelegate?
    override func deleteBackward() {
        super.deleteBackward()
        thisDelegate?.textFieldDidChange(textField: self)
    }
}
