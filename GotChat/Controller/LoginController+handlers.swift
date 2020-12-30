//
//  LoginController+handlers.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 11/23/20.
//

import UIKit
import Firebase
import MBProgressHUD

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}

extension LoginViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
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
        profileImage.image = newImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let pass = passwordTextField.text
            else {
                print("Form is not valid")
                return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        DispatchQueue.global(qos: .userInteractive).async {
            Auth.auth().signIn(withEmail: email, password: pass) { (authResult, error) in
                if error != nil {
                    print("Sign error", error!)
                }
                
                MBProgressHUD.hide(for: self.view, animated:  true)
                self.dismiss(animated: true, completion: nil)
                print("successfully signed in!", email)
            }
        }
    }
    
    @objc func handleRegister() {
        guard let email = emailTextField.text, let pass = passwordTextField.text, let name = nameTextField.text
            else {
                print("Form is not valid")
            return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Auth.auth().createUser(withEmail: email, password: pass) { (authResult, error) in
            if error != nil {
                print("Auth error", error!)
                return
            
        }
            guard let userID = Auth.auth().currentUser?.uid else {
                return
            }
            
            let storageRef = Storage.storage().reference().child("profileImages").child("\(userID).png")
            
            if let uploadData = self.profileImage.image?.jpegData(compressionQuality: 0.1) {
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
