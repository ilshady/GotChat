//
//  ChatLog+handlers.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 30.12.2020.
//

import UIKit
import EasyPeasy
import Firebase

extension ChatLogController {
      
@objc func handleKeyboardNotification(notification: NSNotification) {
    if let userInfo = notification.userInfo {
        if let keyboardFrame = (userInfo["UIKeyboardFrameEndUserInfoKey"] as? NSValue)?.cgRectValue {
            let isKeyboardShowing = notification.name.rawValue == "UIKeyboardWillShowNotification"
            keyboardHeight = keyboardFrame.height
            
            if isKeyboardShowing {
                inputTextView.easy.reload()
                inputTextView.easy.layout(Bottom(keyboardHeight+8).to(view,.bottom),
                                          Height(<=inputTextViewHeightConstant))
                sendButton.easy.layout(Bottom(keyboardHeight+8).to(view,.bottom))
            } else {
                inputTextView.easy.layout(Bottom(8).to(view.safeAreaLayoutGuide,.bottom),
                                          Height(inputTextView.frame.height))
                sendButton.easy.layout(Bottom(8).to(view.safeAreaLayoutGuide,.bottom))
            }
        }
    }
}

override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    inputTextView.endEditing(true)
}
    

@objc func buttonPressed() {
    let ref = Database.database().reference().child("messages")
    let childRef = ref.childByAutoId()
    let fromId = Auth.auth().currentUser!.uid
    let toId = user!.id
    let timeStamp = NSNumber(value: NSDate().timeIntervalSince1970)
    let values = ["text": inputTextView.text!,"fromId": fromId ,"toId": toId, "timeStamp": timeStamp] as [String : Any]
    childRef.updateChildValues(values)
    inputTextView.text.removeAll()
}



func textViewDidChange(_ textView: UITextView) {
    if inputTextView.contentSize.height >= inputTextViewHeightConstant {
        inputTextView.isScrollEnabled = true
    } else {
        inputTextView.isScrollEnabled = false
        textView.setNeedsUpdateConstraints()
    }
}

func textViewDidBeginEditing(_ textView: UITextView) {
        inputTextView.becomeFirstResponder()
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
        textView.text = "Message"
        textView.textColor = .lightGray
    }
}
}

