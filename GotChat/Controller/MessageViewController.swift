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
    var messages = [Message]()
    var messageDict = [String: Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UserCell.self, forCellReuseIdentifier: "cellId")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "compose"), style: .plain, target: self, action: #selector(handleCompose))
        
    }
        //TO DO: fix the message duplicate problem
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
            let ref = Database.database().reference().child("user-messages").child(uid)
            ref.observe(.childAdded) { (snapshot) in
                let messageID = snapshot.key
                let messagesRef = Database.database().reference().child("messages").child(messageID)
                messagesRef.observeSingleEvent(of: .value) { (snapshot) in
                    if let dict = snapshot.value as? NSDictionary {
                        let fromID = dict["fromId"] as? String ?? ""
                        let text = dict["text"] as? String ?? ""
                        let timeStamp = dict["timeStamp"] as? NSNumber ?? 0
                        let toID = dict["toId"] as? String ?? ""
                        
                        let message = Message(fromID: fromID, text: text, timeStamp: timeStamp, toID: toID)
                        
                        self.messageDict[toID] = message
                        self.messages = Array(self.messageDict.values)
                        self.messages.sort { $0.timeStamp.intValue > $1.timeStamp.intValue
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loginCheck()
        observeUserMessages()
    }
    
    @objc func handleCompose() {
        newMessageVC.messageVC = self
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
    
    func observeMessages() {
        
        DispatchQueue.global().async {
            let ref = Database.database().reference().child("messages")
            ref.observe(.childAdded) { (snapshot) in
                if let dict = snapshot.value as? NSDictionary {
                    let fromID = dict["fromId"] as? String ?? ""
                    let text = dict["text"] as? String ?? ""
                    let timeStamp = dict["timeStamp"] as? NSNumber ?? 0
                    let toID = dict["toId"] as? String ?? ""
                    
                    let message = Message(fromID: fromID, text: text, timeStamp: timeStamp, toID: toID)
                    
                    self.messageDict[toID] = message
                    self.messages = Array(self.messageDict.values)
                    self.messages.sort { $0.timeStamp.intValue > $1.timeStamp.intValue
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func loginCheck() {
            let uid = Auth.auth().currentUser?.uid
            if uid == nil {
                self.perform(#selector(self.handleLogout), with: nil, afterDelay: 0)
            } else {
                Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
                    if let dictionary = snapshot.value as? NSDictionary {
                        let id = snapshot.key
                        let name = dictionary["name"] as? String ?? ""
                        let email = dictionary["email"] as? String ?? ""
                        let url = dictionary["url"] as? String ?? ""
                        
                        let user = User(id: id, name: name, email: email, url: url)
                        
                        self.setupNavBar(user: user)
                        DispatchQueue.main.async {
                            self.navigationItem.title = dictionary["name"] as? String
                        }
                    }
                }
            }
    }
    
    func setupNavBar(user: User) {
        
        messages.removeAll()
        messageDict.removeAll()
        tableView.reloadData()
        
        let titleView = UIView()
        titleView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: 44).isActive = true
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

    }
    
    func showChatLogForUser(user: User) {
        let chatLogVC = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogVC.user = user
        navigationController?.pushViewController(chatLogVC, animated: true)
    }
}

extension MessageViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! UserCell
        let message = messages[indexPath.row]
        
        cell.message = message
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? NSDictionary {
                let id = snapshot.key
                let name = dictionary["name"] as? String ?? ""
                let email = dictionary["email"] as? String ?? ""
                let url = dictionary["url"] as? String ?? ""
                
                let user = User(id: id, name: name, email: email, url: url)
                self.showChatLogForUser(user: user)
            }
        }
    }
    
}
