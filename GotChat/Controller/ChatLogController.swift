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
    let inputTextViewHeightConstant: CGFloat = 130.66666666666666
    let cellId = "cellId"
    var messages = [Message]()

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
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)

        collectionView.backgroundColor = .white
        inputTextView.delegate = self

        setupInputComponents()

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }


    let containerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .systemGroupedBackground
        return container
    }()

    let innerContainerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .none
        return container
    }()

    let inputTextView: UITextView = {
        let input = UITextView()
        input.font = UIFont.systemFont(ofSize: 16)
        input.textContainerInset.left = 8
        input.translatesAutoresizingMaskIntoConstraints = false
        input.isEditable = true
        input.layer.cornerRadius = 18
        input.layer.masksToBounds = true
        input.layer.borderWidth = 0.2
        input.layer.borderColor = UIColor.gray.cgColor
        input.text = "Message"
        input.textColor = .lightGray
        input.sizeToFit()
        input.isScrollEnabled = false
        return input
    }()

    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()

    let separator: UIView = {
        let sep = UIView()
        sep.translatesAutoresizingMaskIntoConstraints = false
        sep.backgroundColor = .gray
        return sep
    }()

    func setupInputComponents() {

        let guide = view.safeAreaLayoutGuide

        view.addSubview(containerView)

        containerView.addSubview(separator)
        containerView.addSubview(inputTextView)
        containerView.addSubview(sendButton)
        
        containerView.easy.layout(
            Left().to(view,.left),
            Right().to(view,.right),
            Bottom().to(view,.bottom)
        )
        
        separator.easy.layout(
            Left().to(view,.left),
            Right().to(view,.right),
            Top().to(containerView,.top),
            Height(0.2)
        )
        
        inputTextView.easy.layout(
            Left(8).to(containerView,.left),
            Right().to(sendButton,.left),
            Top(8).to(containerView,.top),
            Bottom(8).to(guide,.bottom),
            Height(<=inputTextViewHeightConstant)
        )
        
        sendButton.easy.layout(
            Left().to(inputTextView,.right),
            Right().to(containerView,.right),
            Bottom().to(inputTextView,.bottom),
            Height(40),
            Width(80)
        )

    }
    
}
    
extension ChatLogController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.row]
        cell.textView.text = message.text
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
}
