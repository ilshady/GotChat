//
//  LoginControllerViewController.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 11/11/20.
//

import UIKit
import EasyPeasy
import MBProgressHUD
import Firebase

protocol LoginViewDeligate {
    func profileImageTapped()
    func registerButtonPressed()
    func toggleChanged()
}

enum ToggleState: Int {
    case login
    case register
}

class LoginViewController: UIViewController, LoginViewDeligate {
    
    lazy var loginView = LoginView()
        
    // MARK: - Methods
    override func loadView() {
        self.view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginView.viewDeligate = self
    }
    
    func registerButtonPressed() {
        loginView.toggle.selectedSegmentIndex == ToggleState.login.rawValue ?
            handleLogin() :
            handleRegister()
    }
    
    func toggleChanged() {
        let toggleTitle = loginView.toggle.titleForSegment(at: loginView.toggle.selectedSegmentIndex)
        loginView.registerButton.setTitle(toggleTitle, for: .normal)
    }
    
    func profileImageTapped() {
        handleProfileImageSelect()
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
//MARK: Extensions
extension UIViewController {
    
    func showAlert(title: String? , message: String) {
        MBProgressHUD.hide(for: self.view, animated:  true)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}


