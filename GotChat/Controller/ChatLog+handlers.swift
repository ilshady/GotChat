//
//  ChatLog+handlers.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 30.12.2020.
//

import UIKit
import EasyPeasy
import Firebase

extension ChatLogController: UITextViewDelegate {
      //TO DO: Fix the height sticking issue 
@objc func handleKeyboardNotification(notification: NSNotification) {
    if let userInfo = notification.userInfo {
        if let keyboardFrame = (userInfo["UIKeyboardFrameEndUserInfoKey"] as? NSValue)?.cgRectValue {
            let isKeyboardShowing = notification.name.rawValue == "UIKeyboardWillShowNotification"
            keyboardHeight = keyboardFrame.height
            
            if isKeyboardShowing {
                inputContainerView.inputTextView.easy.layout(Bottom(keyboardHeight+8).to(view,.bottom))
            } else {
                inputContainerView.inputTextView.easy.layout(Bottom(8).to(view.safeAreaLayoutGuide,.bottom))
            }
        }
    }
}

@objc func buttonPressed() {
    let ref = Database.database().reference().child("messages")
    let childRef = ref.childByAutoId()
    let fromId = Auth.auth().currentUser!.uid
    let toId = user!.id
    let timeStamp = NSNumber(value: Date().timeIntervalSince1970)
    let values = ["text": inputContainerView.inputTextView.text!,"fromId": fromId ,"toId": toId, "timeStamp": timeStamp] as [String : Any]
//    childRef.updateChildValues(values)
    
    childRef.updateChildValues(values) { (err, ref) in
        if err != nil {
            print(err!)
            return
        }
        let userMessagesRef = Database.database().reference().child("user-messages").child(fromId)
        guard let messageID = childRef.key else {
                        return
                    }
        userMessagesRef.updateChildValues([messageID: true])
        
        let reciepientUserMessageRef = Database.database().reference().child("user-messages").child(toId)
        reciepientUserMessageRef.updateChildValues([messageID: true])
    }
    
    inputContainerView.inputTextView.text.removeAll()
}

func textViewDidChange(_ textView: UITextView) {
    if inputContainerView.inputTextView.contentSize.height >= inputContainerView.inputTextViewHeightConstant {
        inputContainerView.inputTextView.isScrollEnabled = true
    } else {
        inputContainerView.inputTextView.isScrollEnabled = false
        inputContainerView.inputTextView.layoutIfNeeded()
        inputContainerView.inputTextView.setNeedsLayout()
        textView.setNeedsUpdateConstraints()
    }
}

func textViewDidBeginEditing(_ textView: UITextView) {
    inputContainerView.inputTextView.becomeFirstResponder()
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

extension ChatLogController: UserMessagesDeligate {
    func didUpdateMessages() {
        navigationItem.title = user?.name
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension ChatLogController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageViewModel.messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messageViewModel.messages[indexPath.item]
        cell.textView.text = message.text
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        let text = messageViewModel.messages[indexPath.item].text
        height = estimateFrameForText(text).height + 20
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputContainerView.inputTextView.endEditing(true)
    }
}
