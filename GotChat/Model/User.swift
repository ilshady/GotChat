//
//  Users.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 11/16/20.
//

import UIKit
import Firebase

struct User {
    public let id: String
    public let name: String
    public let email: String
    public let url: String?
}

struct Message {
    public let fromID: String
    public let text: String
    public let timeStamp: NSNumber
    public let toID: String
    
    public func chatPartnerId() -> String? {
        return fromID == Auth.auth().currentUser?.uid ? toID : fromID
    }
}
