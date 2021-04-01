//
//  ChatLogController.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 12/8/20.
//

import UIKit
import EasyPeasy
import Firebase

class ChatLogController: UICollectionViewController, UITextViewDelegate {

    var keyboardHeight: CGFloat = 0.0
    let cellId = "cellId"
    var messages = [Message]()
    
    lazy var inputContainerView = ChatInputContainerView()

    var user: User? {
        didSet {
            navigationItem.title = user?.name
            
            observeMessages()
        }
    }
    
    func observeMessages() {
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
                    
                    if message.chatPartnerId() == self.user?.id {
                    self.messages.append(message)
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    }
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        inputContainerView.inputTextView.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addSubview(inputContainerView)
        
        inputContainerView.easy.layout(
            Left().to(view,.left),
            Right().to(view,.right),
            Bottom().to(view,.bottom)
        )
        
    }
    
}
    
extension ChatLogController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        let text = messages[indexPath.item].text
        height = estimateFrameForText(text).height + 20
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
}
