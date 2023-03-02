//
//  PhoneAuthViewController.swift
//  datingApp
//
//  Created by Jack Walker on 3/1/23.
//

import UIKit

protocol numTextFieldDelegate {
    func textFieldDidDelete()
}

class PhoneAuthViewController: UIViewController, UITextFieldDelegate, numTextFieldDelegate {
    func textFieldDidDelete() {
        
    }
    
    private var numTextFields = [UITextField]()
    private var bottomLines = [CALayer]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        for i in 0...5 {
            let field = numTextFields[i]
            let bottomLine = bottomLines[i]
            field.delegate = self
            field.addTarget(self, action: #selector(textFieldDidChange(textField: )), for: .editingChanged)
            field.keyboardType = .numberPad
            field.backgroundColor = .white
            field.textColor = .black
            field.textAlignment = .center
            field.font = .systemFont(ofSize: 25)
            bottomLine.backgroundColor = UIColor.darkGray.cgColor
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
        input1.frame = CGRect(x: 30,
                              y: 100,
                              width: 50,
                              height: 50)
        bottomLine1.frame = CGRect(x: 30,
                                   y: 151,
                                   width: 50,
                                   height: 2)
        input2.frame = CGRect(x: input1.right + 10,
                              y: 100,
                              width: 50,
                              height: 50)
        bottomLine2.frame = CGRect(x: input1.right + 10,
                                   y: 151,
                                   width: 50,
                                   height: 2)
        input3.frame = CGRect(x: input2.right + 10,
                              y: 100,
                              width: 50,
                              height: 50)
        bottomLine3.frame = CGRect(x: input2.right + 10,
                                   y: 151,
                                   width: 50,
                                   height: 2)
        input4.frame = CGRect(x: input3.right + 10,
                              y: 100,
                              width: 50,
                              height: 50)
        bottomLine4.frame = CGRect(x: input3.right + 10,
                                   y: 151,
                                   width: 50,
                                   height: 2)
        input5.frame = CGRect(x: input4.right + 10,
                              y: 100,
                              width: 50,
                              height: 50)
        bottomLine5.frame = CGRect(x: input4.right + 10,
                                   y: 151,
                                   width: 50,
                                   height: 2)
        input6.frame = CGRect(x: input5.right + 10,
                              y: 100,
                              width: 50,
                              height: 50)
        bottomLine6.frame = CGRect(x: input5.right + 10,
                                   y: 151,
                                   width: 50,
                                   height: 2)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        let text = textField.text
        
        if  text?.count == 1 {
            switch textField {
            case input1:
                input2.becomeFirstResponder()
            case input2:
                input3.becomeFirstResponder()
            case input3:
                input4.becomeFirstResponder()
            case input4:
                input5.becomeFirstResponder()
            case input5:
                input6.becomeFirstResponder()
            case input6:
                input6.resignFirstResponder()
                self.view.endEditing(true)
            default:
                break
            }
        }
        
        if  text?.count == 0 {
            switch textField {
            case input1:
                input1.becomeFirstResponder()
            case input2:
                input1.becomeFirstResponder()
            case input3:
                input2.becomeFirstResponder()
            case input4:
                input3.becomeFirstResponder()
            case input5:
                input4.becomeFirstResponder()
            case input6:
                input5.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("in function")
        if let char = string.cString(using: String.Encoding.utf8) {
            print("not nil")
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                switch textField {
                case input1:
                    input1.becomeFirstResponder()
                case input2:
                    input2.text = ""
                    input1.becomeFirstResponder()
                case input3:
                    input3.text = ""
                    input2.becomeFirstResponder()
                case input4:
                    input4.text = ""
                    input3.becomeFirstResponder()
                case input5:
                    input5.text = ""
                    input4.becomeFirstResponder()
                case input6:
                    input6.text = ""
                    input5.becomeFirstResponder()
                default:
                    break
                }
            }
            
        }
        return true
    }
}



class numberTextField : UITextField {
    var myDelegate : numTextFieldDelegate!
    override func deleteBackward() {
        super.deleteBackward()
        myDelegate.textFieldDidDelete()
    }
}
