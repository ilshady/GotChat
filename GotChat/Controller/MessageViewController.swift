//
//  ViewController.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 11/11/20.
//

import UIKit
import Firebase
import EasyPeasy

class MessageViewController: UITableViewController {
    
    let loginVC = LoginViewController()
    let newMessageVC = NewMessageTableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "compose"), style: .plain, target: self, action: #selector(handleCompose))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loginCheck()
    }
    
    @objc func handleCompose() {
        let navController = UINavigationController(rootViewController: newMessageVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC,animated: true)
        
    }
    
    func loginCheck() {
        
            let uid = Auth.auth().currentUser?.uid
            if uid == nil {
                self.perform(#selector(self.handleLogout), with: nil, afterDelay: 0)
            } else {
                Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
                    if let dictionary = snapshot.value as? NSDictionary {
                        let name = dictionary["name"] as? String ?? ""
                        let email = dictionary["email"] as? String ?? ""
                        let url = dictionary["url"] as? String ?? ""
                        
                        let user = User(name: name, email: email, url: url)
                        
                        self.setupNavBar(user: user)
                        DispatchQueue.main.async {
                            self.navigationItem.title = dictionary["name"] as? String
                        }
                    }
                }
            }
        
        
    }
    
    func setupNavBar(user: User) {
        
        let titleView = UIView()
        titleView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        titleView.backgroundColor = .red
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        let profileImageView = UIImageView()
        if let urlString = user.url {
        profileImageView.loadImages(urlString: urlString)
        }
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.masksToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.addSubview(profileImageView)
        titleView.addSubview(nameLabel)
        
        profileImageView.easy.layout(
            Left(0).to(titleView),
            CenterY(0),
            Width(40),
            Height(40)
        )
        
        nameLabel.easy.layout(
            Left(10).to(profileImageView),
            CenterY(0)
        )
        

        self.navigationItem.titleView = titleView
        
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatLog)))

    }
    
    @objc func showChatLog() {
        let chatLog = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(chatLog, animated: true)
    }
}

