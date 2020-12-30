//
//  UserCell.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 30.12.2020.
//

import UIKit
import EasyPeasy
import Firebase

class UserCell: UITableViewCell {
    
    var message: Message? {
        didSet {
            let toID = message!.toID
                let ref = Database.database().reference().child("users").child(toID)
                ref.observeSingleEvent(of: .value) { (snapshot) in
                    if let dictionary = snapshot.value as? NSDictionary  {
                        let name = dictionary["name"] as? String ?? ""
                        let url = dictionary["url"] as? String ?? ""
                        
                        self.textLabel?.text = name
                        self.profileImageView.loadImages(urlString: url)
                    }
                }

            detailTextLabel?.text = message!.text
        }
    }

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
