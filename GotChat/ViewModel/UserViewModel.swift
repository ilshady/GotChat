//
//  Network.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 02.04.2021.
//

import UIKit
import Firebase
import MBProgressHUD


class UserViewModel {
    
    func handleLogin(email: String, pass: String) {
        
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
