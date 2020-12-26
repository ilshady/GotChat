//
//  ChatLogController.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 12/8/20.
//

import UIKit
import EasyPeasy
import CoreGraphics

class ChatLogController: UICollectionViewController, UITextViewDelegate {
    
    var viewBottomConstraint: NSLayoutConstraint?
    var innerContainerConstraint: NSLayoutConstraint?

        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        navigationItem.title = "Something"
        collectionView.backgroundColor = .white
        inputTextView.delegate = self
        
        setupInputComponents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame = (userInfo["UIKeyboardFrameEndUserInfoKey"] as? NSValue)?.cgRectValue {
                viewBottomConstraint?.constant = -keyboardFrame.height
                innerContainerConstraint?.constant = -keyboardFrame.height
            }
        }
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
        input.textContainerInset.left = 10
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
        containerView.addSubview(innerContainerView)
        containerView.addSubview(separator)
        innerContainerView.addSubview(inputTextView)
        innerContainerView.addSubview(sendButton)
                
        containerView.easy.layout(
            Left(0).to(view,.left),
            Width(0).like(view,.width)
        )
        
        innerContainerView.easy.layout(
            Left(0).to(containerView,.left),
            Right(0).to(containerView,.right),
            Height(200),
            Top().to(inputTextView)
        )
        
        separator.easy.layout(
            Left(0).to(containerView,.left),
            Top(0).to(containerView,.top),
            Width(0).like(containerView,.width),
            Height(0.2)
        )
        
        inputTextView.easy.layout(
            Left(8).to(view,.left),
            Top(8).to(containerView,.top),
            Bottom(8).to(innerContainerView,.bottom),
            Right(0).to(sendButton,.left),
            Height(<=160)
        )
        
        sendButton.easy.layout(
            Right(0).to(containerView,.right),
            //Top(8).to(containerView,.top),
            Bottom(8).to(innerContainerView,.bottom),
            Width(80),
            Height(40)
        )
        
        viewBottomConstraint = NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        innerContainerConstraint = NSLayoutConstraint(item: innerContainerView, attribute: .bottom, relatedBy: .equal, toItem: guide, attribute: .bottom, multiplier: 1, constant: -8)
        view.addConstraint(viewBottomConstraint!)
        view.addConstraint(innerContainerConstraint!)
      
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.bringSubviewToFront(containerView)
        containerView.bringSubviewToFront(innerContainerView)
        innerContainerView.bringSubviewToFront(inputTextView)
    }
    
    @objc func buttonPressed() {
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        inputTextView.becomeFirstResponder()
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if inputTextView.contentSize.height >= 149.66666666666666 {
            inputTextView.isScrollEnabled = true
        } else {
            inputTextView.isScrollEnabled = false
        }

    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = .lightGray
        }
    }
}
