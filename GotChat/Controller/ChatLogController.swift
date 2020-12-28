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
            Right().to(view,.right)
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
            Height(<=144.5)
        )
        
        sendButton.easy.layout(
            Left().to(inputTextView,.right),
            Right().to(containerView,.right),
            Bottom(8).to(guide,.bottom),
            Height(40),
            Width(80)
        )

        viewBottomConstraint = NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: guide, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(viewBottomConstraint!)

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
        if inputTextView.contentSize.height >=  140 {
            inputTextView.isScrollEnabled = true
        } else {
            inputTextView.isScrollEnabled = false
            textView.setNeedsUpdateConstraints()

        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Message"
            textView.textColor = .lightGray
        }
    }
}
