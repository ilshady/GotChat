//
//  NewMessageTableViewController.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 11/14/20.
//

import UIKit
import Firebase
import EasyPeasy

class NewMessageTableViewController: UITableViewController {
    
    let cellId = "cellId"
    var users = [User]()
    var messageVC: MessageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleCancel))
        fetchUser()
    }
    
    func fetchUser() {
            Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
                if let value = snapshot.value as? NSDictionary  {
                    let id = snapshot.key
                    let name = value["name"] as? String ?? ""
                    let email = value["email"] as? String ?? ""
                    let imageURL = value["url"] as? String ?? ""

                    let user = User(id: id, name: name, email: email, url: imageURL)
                    self.users.append(user)
                }
                self.tableView.reloadData()
            }
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        let urlString = user.url!
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        cell.profileImageView.loadImages(urlString: urlString)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            tableView.isUserInteractionEnabled = false
            let user = self.users[indexPath.row]
            self.messageVC?.showChatLogForUser(user: user)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

}
