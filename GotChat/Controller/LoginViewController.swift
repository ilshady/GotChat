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

class LoginViewController: UIViewController {
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
   
    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.layer.cornerRadius = 5
        button.setTitle("Register", for: .normal)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let toggle: UISegmentedControl = {
        let toggle = UISegmentedControl(items: ["Login","Register"])
        toggle.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        toggle.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(r: 80, g: 101, b: 161)], for: .selected)
        toggle.selectedSegmentIndex = 1
        toggle.addTarget(self, action: #selector(handleRegisterChange), for: .valueChanged)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "logo")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfileImageSelect)))
        image.isUserInteractionEnabled = true
        return image
    }()
    
    let nameTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Name"
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let nameSeparatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    
    let emailTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Email"
        text.autocapitalizationType = .none
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let emailSeparatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    
    let passwordTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Password"
        text.textContentType = .newPassword
        text.isSecureTextEntry = true
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        setupSubviews()
        setupInputContainerView()
    }
    
    func setupSubviews() {
        setupInputContainerView()
        
        view.addSubview(toggle)
        view.addSubview(inputContainerView)
        view.addSubview(registerButton)
        view.addSubview(profileImage)
        
        profileImage.easy.layout(
            CenterX(0),
            Bottom(12).to(toggle,.top),
            Width(150),
            Height(150)
        )
        toggle.easy.layout(
            CenterX(0),
            Bottom(12).to(inputContainerView,.top),
            Width(0).like(inputContainerView),
            Height(35)
        )
        inputContainerView.easy.layout(
            CenterX(0.0),
            CenterY(0.0).when({self.toggle.selectedSegmentIndex == 1}),
            CenterY(-25).when({self.toggle.selectedSegmentIndex == 0}),
            Width(-24).like(view),
            Height(150).when({self.toggle.selectedSegmentIndex == 1}),
            Height(100).when({self.toggle.selectedSegmentIndex == 0})
        )
        registerButton.easy.layout(
            CenterX(0),
            Top(12).to(inputContainerView),
            Width(0).like(inputContainerView),
            Height(40)
            )
    }
    
    func setupInputContainerView() {
        [nameTextField, nameSeparatorView, emailTextField,emailSeparatorView, passwordTextField].forEach {
            inputContainerView.addSubview($0)
        }
                
        nameTextField.easy.layout(
            Top(0).to(inputContainerView),
            Left(12).to(inputContainerView),
            Width(0).like(inputContainerView),
            Height(*(1/3)).like(inputContainerView).when({ self.toggle.selectedSegmentIndex == 1}),
            Height(0).when({ self.toggle.selectedSegmentIndex == 0})
        )
        nameSeparatorView.easy.layout(
            Top(0).to(nameTextField),
            Width(0).like(inputContainerView),
            Height(1)
        )
        emailTextField.easy.layout(
            Top(0).to(nameSeparatorView),
            Left(12).to(inputContainerView),
            Width(0).like(inputContainerView),
            Height(*(1/3)).like(inputContainerView).when({ self.toggle.selectedSegmentIndex == 1}),
            Height(*(1/2)).like(inputContainerView).when({ self.toggle.selectedSegmentIndex == 0})
        )
        emailSeparatorView.easy.layout(
            Top(0).to(emailTextField),
            Width(0).like(inputContainerView),
            Height(1)
        )
        passwordTextField.easy.layout(
            Top(0).to(emailSeparatorView,.top),
            Left(12).to(inputContainerView),
            Width(0).like(inputContainerView),
            Height(*(1/3)).like(inputContainerView).when({ self.toggle.selectedSegmentIndex == 1}),
            Height(*(1/2)).like(inputContainerView).when({ self.toggle.selectedSegmentIndex == 0})
        )
        
    }

    @objc func handleRegisterChange() {
        let toggleTitle = toggle.titleForSegment(at: toggle.selectedSegmentIndex)
        registerButton.setTitle(toggleTitle, for: .normal)
        setupSubviews()
    }
    
    @objc func handleLoginRegister() {
        if toggle.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    

    
}


