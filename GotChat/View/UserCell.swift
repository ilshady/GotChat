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
            
            if let seconds = message?.timeStamp.doubleValue {
                let timeStampDate = Date(timeIntervalSince1970: seconds)
                dateRepresentation(date: timeStampDate)
            }
        }
    }
    
    func dateRepresentation(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        if calendar.isDateInToday(date) {
            timeLabel.text = dateFormatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            timeLabel.text = "Yesterday"
        } else {
            let weekDay = dateFormatter.weekdaySymbols[calendar.component(.weekday, from: date)-1]
            timeLabel.text = weekDay
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
    
    let timeLabel: UILabel = {
       let label = UILabel()
        label.text = "HH:MM"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        profileImageView.easy.layout(
            Left(8),
            CenterY(0),
            Width(52),
            Height(52)
        )
        
        //THE KOSTYL MADAFAKA
        [timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -14),
         timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 14),
        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor)].forEach({$0.isActive = true})
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
