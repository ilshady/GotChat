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

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: cellId)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleCancel))
        fetchUser()
    }
    
    func fetchUser() {
            Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
                if let value = snapshot.value as? NSDictionary  {
                    let name = value["name"] as? String ?? ""
                    let email = value["email"] as? String ?? ""
                    let imageURL = value["url"] as? String ?? ""

                    let user = User(name: name, email: email, url: imageURL)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TableViewCell
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

}

class TableViewCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: profileImageView.frame.maxX+8, y: textLabel!.frame.origin.y-2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: profileImageView.frame.maxX+8, y: detailTextLabel!.frame.origin.y+2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    var profileImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 26
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = true
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        
        profileImageView.easy.layout(
            Left(8),
            CenterY(0),
            Width(52),
            Height(52)
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
