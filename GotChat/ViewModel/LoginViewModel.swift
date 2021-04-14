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
    
    func handleLogin(email: String, password: String, controller: UIViewController) {
        
        MBProgressHUD.showAdded(to: controller.view, animated: true)
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                controller.showAlert(title: "Check your inputs", message: "\(error!)")
            } else {
                
                MBProgressHUD.hide(for: controller.view, animated:  true)
                controller.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func handleRegister(email: String, password: String, name: String, profileImage: UIImage, controller: UIViewController) {
        
        MBProgressHUD.showAdded(to: controller.view, animated: true)
        DispatchQueue.global(qos: .userInteractive).async {
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if error != nil {
                    controller.showAlert(title: "Check your inputs", message: "\(error!)")
                    return
                }
                guard let userID = Auth.auth().currentUser?.uid else {
                    return
                }
                
                let storageRef = Storage.storage().reference().child("profileImages").child("\(userID).png")
                
                if let uploadData = profileImage.jpegData(compressionQuality: 0.1) {
                    storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                        if error != nil {
                            print(error!)
                        }
                        storageRef.downloadURL { (url, error) in
                            if error != nil {
                                print(error!)
                            }
                            if let imageUrl = url?.absoluteString {
                                let values = ["name": name, "email": email, "url": imageUrl]
                                self.registerUserIntoDB(uid: userID, values: values)
                                MBProgressHUD.hide(for: controller.view, animated: true)
                                controller.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func registerUserIntoDB(uid: String, values: [String:String]) {
        let ref = Database.database().reference()
        let userReference = ref.child("users").child(uid)
        
        userReference.updateChildValues(values) { (err, ref) in
            if err != nil {
                print(err!)
            }
            
            print("user successfully added to db")
        }
        
    }
}


