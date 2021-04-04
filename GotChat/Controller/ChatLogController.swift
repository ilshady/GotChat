//
//  ChatLogController.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 12/8/20.
//

import UIKit
import EasyPeasy
import Firebase

class ChatLogController: UICollectionViewController  {

    var keyboardHeight: CGFloat = 0.0
    let cellId = "cellId"
    var messageViewModel = MessageViewModel()
    
    lazy var inputContainerView = ChatInputContainerView()

    var user: User? {
        didSet {
            messageViewModel.observeMessages(user: user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageViewModel.messagesDeligate = self
        inputContainerView.inputTextView.delegate = self
        
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        view.backgroundColor = .white
        collectionView.backgroundColor = .white

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
