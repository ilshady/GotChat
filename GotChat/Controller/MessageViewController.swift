//
//  ViewController.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 11/11/20.
//

import UIKit

class MessageViewController: UITableViewController {
    
    let loginVC = LoginViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    @objc func handleLogout() {
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC,animated: true)
        
    }


}

