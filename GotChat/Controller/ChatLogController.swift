//
//  ChatLogController.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 12/8/20.
//

import UIKit
import EasyPeasy
import Firebase

class ChatLogController: UIViewController  {

    var keyboardHeight: CGFloat = 0.0
    var messageViewModel = MessageViewModel()
    let layout = UICollectionViewFlowLayout()
    
    var user: User? {
        didSet {
            messageViewModel.observeMessages(user: user)
        }
    }
        
    lazy var inputContainerView = ChatInputContainerView()
    lazy var messagesCollectionView = MessagesCollectionView()
    
    override func loadView() {
        messagesCollectionView = MessagesCollectionView(frame: .zero, collectionViewLayout: layout)
        self.view = messagesCollectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messageViewModel = messageViewModel
        
        messageViewModel.messagesDeligate = self
        inputContainerView.inputTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
//        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
//        addGestureRecognizer(tap)
        
    }
    
}
