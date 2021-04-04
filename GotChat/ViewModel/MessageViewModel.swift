//
//  MessageViewModel.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 04.04.2021.
//

import UIKit
import Firebase

protocol UserMessagesDeligate {
    func didUpdateMessages()
}

class MessageViewModel {
    
    var messages = [Message]()
    var messagesDeligate: UserMessagesDeligate?
    
    func observeMessages(user: User?) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid)
        
        userMessagesRef.observe(.childAdded) { (snapshot) in
            let messageID = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageID)
            messagesRef.observeSingleEvent(of: .value) { (snapshot) in
                if let dict = snapshot.value as? NSDictionary {
                    let fromID = dict["fromId"] as? String ?? ""
                    let text = dict["text"] as? String ?? ""
                    let timeStamp = dict["timeStamp"] as? NSNumber ?? 0
                    let toID = dict["toId"] as? String ?? ""
                    
                    let message = Message(fromID: fromID, text: text, timeStamp: timeStamp, toID: toID)
                    
                    if message.chatPartnerId() == user?.id {
                    self.messages.append(message)
                        
                        self.messagesDeligate?.didUpdateMessages()
                    
                    }
                }
            }
        }
        
    }
    
}