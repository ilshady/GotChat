//
//  LoginView.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 31.03.2021.
//

import UIKit
import EasyPeasy

class LoginView: UIView {
    
    var viewDeligate: LoginViewDeligate?
    
    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "mainBlue")
        button.layer.cornerRadius = 5
        button.setTitle("Register", for: .normal)
        button.addTarget(self, action: #selector(handleRegisterButton), for: .touchUpInside)
        return button
    }()
    
    let toggle: UISegmentedControl = {
        let toggle = UISegmentedControl(items: ["Login","Register"])
        toggle.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        toggle.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(r: 80, g: 101, b: 161)], for: .selected)
        toggle.selectedSegmentIndex = 1
        toggle.addTarget(self, action: #selector(handleToggle), for: .valueChanged)
        return toggle
    }()
    
    lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "logo")
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfileImage)))
        return image
    }()
    
    let nameTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Name"
        return text
    }()
    
    let nameSeparatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        return separator
    }()
    
    let emailTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Email"
        text.autocapitalizationType = .none
        return text
    }()
    
    let emailSeparatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        return separator
    }()
    
    let passwordTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Password"
        text.textContentType = .newPassword
        text.isSecureTextEntry = true
        return text
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [
            toggle,
            inputContainerView,
            registerButton,
            profileImage,
            nameTextField,
            nameSeparatorView,
            emailTextField,
            emailSeparatorView,
            passwordTextField
        ].forEach({addSubview($0)})
        
        
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
            Width(-24).like(self),
            Height(150).when({self.toggle.selectedSegmentIndex == 1}),
            Height(100).when({self.toggle.selectedSegmentIndex == 0})
        )
        registerButton.easy.layout(
            CenterX(0),
            Top(12).to(inputContainerView),
            Width(0).like(inputContainerView),
            Height(40)
            )
        
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LoginView {
    @objc func handleProfileImage() {
        viewDeligate?.profileImageTapped()
    }
    
    @objc func handleRegisterButton() {
        viewDeligate?.registerButtonPressed()
    }
    
    @objc func handleToggle() {
        viewDeligate?.toggleChanged()
    }
}
