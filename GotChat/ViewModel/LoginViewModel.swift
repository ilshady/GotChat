//
//  LoginViewModel.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 07.04.2021.
//

import UIKit
import Firebase
import MBProgressHUD

class LoginVewModel  {
    
    func handleLogin() {
        
        guard let email = loginView.emailTextField.text, let pass = loginView.passwordTextField.text
            else {
                print("Form is not valid")
                return
        }
        
        MBProgressHUD.showAdded(to: view, animated: true)
        
            Auth.auth().signIn(withEmail: email, password: pass) { (authResult, error) in
                if error != nil {
                    self.showAlert(title: "Check your inputs", message: "\(error!)")
                } else {
                
                MBProgressHUD.hide(for: self.view, animated:  true)
                self.dismiss(animated: true, completion: nil)
                }
            }
    }
}


