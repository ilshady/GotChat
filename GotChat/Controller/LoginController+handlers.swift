//
//  LoginController+handlers.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 11/23/20.
//

import UIKit
import Firebase
import MBProgressHUD

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleProfileImageSelect() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true) {}
        picker.modalPresentationStyle = .fullScreen
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let newImage: UIImage
        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        loginView.profileImage.image = newImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func handleLogin() {
        guard let email = loginView.emailTextField.text, let pass = loginView.passwordTextField.text
            else {
                print("Form is not valid")
                return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
            Auth.auth().signIn(withEmail: email, password: pass) { (authResult, error) in
                if error != nil {
                    self.showAlert(title: "Check your inputs", message: "\(error!)")
                } else {
                
                MBProgressHUD.hide(for: self.view, animated:  true)
                self.dismiss(animated: true, completion: nil)
                }
            }
    }
    
    @objc func handleRegister() {
        guard let email = loginView.emailTextField.text, let pass = loginView.passwordTextField.text, let name = loginView.nameTextField.text
        else {
            print("Form is not valid")
            return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global(qos: .userInteractive).async {
            Auth.auth().createUser(withEmail: email, password: pass) { (authResult, error) in
                if error != nil {
                    self.showAlert(title: "Check your inputs", message: "\(error!)")
                    return
                }
                guard let userID = Auth.auth().currentUser?.uid else {
                    return
                }
                
                let storageRef = Storage.storage().reference().child("profileImages").child("\(userID).png")
                
                if let uploadData = self.loginView.profileImage.image?.jpegData(compressionQuality: 0.1) {
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
                                MBProgressHUD.hide(for: self.view, animated: true)
                                self.dismiss(animated: true, completion: nil)
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
