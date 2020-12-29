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

    var user: User? {
        didSet {
            navigationItem.title = user?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            Bottom(8).to(guide,.bottom),
            Height(40),
            Width(80)
        )

    }
    
}
    
