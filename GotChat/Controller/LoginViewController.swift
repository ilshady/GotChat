//
//  LoginControllerViewController.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 11/11/20.
//

import UIKit
import EasyPeasy
import MBProgressHUD

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
    
    func view() -> LoginView {
        return self.view as! LoginView
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


