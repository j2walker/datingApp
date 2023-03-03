//
//  AuthHandler.swift
//  datingApp
//
//  Created by Jack Walker on 3/2/23.
//

import Foundation
import FirebaseAuth

final class AuthHandler {
    static let shared = AuthHandler()
    
    func firebseSignIn(with verificationID: String, verificationCode: String, completion: @escaping (Bool) -> Void) {
        guard let authVerificationID = UserDefaults.standard.value(forKey: "authVerificationID") as? String else {
            print("authVerificationID not saved in userDefaults")
            return
        }
        guard let authVerificationCode = UserDefaults.standard.value(forKey: "authVerificationCode") as? String else {
            print("authVerificationCode not saved in userDefaults")
            return
        }
        guard let _ = UserDefaults.standard.value(forKey: "userPhoneNumber") else {
            print("UserPhoneNumber not saved in userDefaults")
            return
        }
        
        // Creating the authorization credential token to sign in with Firebase
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: authVerificationID,
                                                                 verificationCode: authVerificationCode)
        
        // Attempting to sign in with the created authorization credential
        Auth.auth().signIn(with: credential) { authResult, error in
            guard let result = authResult, error == nil else {
                print("Error signing user in with firebase: \(error!)")
                completion(false)
                return
            }
            let user = result.user
            UserDefaults.standard.set(user.uid, forKey: "userUID")
            completion(true)
        }
        
    }
    
    
    func appleSignIn(compeltion: @escaping (Result<Any, Error>) -> Void) {
        
    }
    
    func facebookSignIn(completion: @escaping (Result<Any, Error>) -> Void) {
        
    }
    
    func firebaseSignOut(completion: @escaping (Bool) -> Void) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            completion(true)
            return
        }
        catch {
            print("Failed to log out")
            completion(false)
            return
        }
    }
}

