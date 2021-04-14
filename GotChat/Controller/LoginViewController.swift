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

enum ToggleState: Int {
    case login
    case register
}

class LoginViewController: UIViewController, LoginViewDelegate {
    
    lazy var loginView = LoginView()
    lazy var loginViewModel = LoginVewModel()
    
    // MARK: - Methods
    override func loadView() {
        self.view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginView.viewDelegate = self
    }
    
    func registerButtonPressed() {
        guard let email = loginView.emailTextField.text, let pass = loginView.passwordTextField.text, let name = loginView.nameTextField.text, let profileImage = loginView.profileImage.image
        else {
            print("Form is not valid")
            return
        }
        loginView.toggle.selectedSegmentIndex == ToggleState.login.rawValue ?
            loginViewModel.handleLogin(email: email, password: pass, controller: self) :
            loginViewModel.handleRegister(email: email, password: pass, name: name, profileImage: profileImage, controller: self)
    }
    
    func toggleChanged() {
        let toggleTitle = loginView.toggle.titleForSegment(at: loginView.toggle.selectedSegmentIndex)
        loginView.registerButton.setTitle(toggleTitle, for: .normal)
    }
    
    func profileImageTapped() {
        let picker = loginView.pickerView
        picker.delegate = self
        present(picker, animated: true) {}
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

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    
}
