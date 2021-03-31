//
//  LoginControllerViewController.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 11/11/20.
//

import UIKit
import EasyPeasy
import Firebase
import MBProgressHUD

protocol SomeProtocol {
    func registerGesture()
}

class LoginViewController: UIViewController, SomeProtocol {
    
    @objc func registerGesture() {
        handleProfileImageSelect()
    }
    
    lazy var loginView = LoginView()
        
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginView.viewDeligate = self
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        //loginView.registerButton.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        //loginView.toggle.addTarget(self, action: #selector(handleRegisterChange), for: .valueChanged)
       // loginView.profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfileImageSelect)))
    }
    
    override func loadView() {
        self.view = LoginView()
    }
    
    func view() -> LoginView {
        return self.view as! LoginView
    }

    @objc func handleRegisterChange() {
        let toggleTitle = loginView.toggle.titleForSegment(at: loginView.toggle.selectedSegmentIndex)
        loginView.registerButton.setTitle(toggleTitle, for: .normal)
    }
    
    @objc func handleLoginRegister() {
        if loginView.toggle.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
}

extension UIViewController {
    
    func showAlert(title: String? , message: String) {
        MBProgressHUD.hide(for: self.view, animated:  true)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}


