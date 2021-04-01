//
//  ChatInputContainerView.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 30.03.2021.
//

import UIKit
import EasyPeasy

class ChatInputContainerView: UIView {
    
    let inputTextViewHeightConstant: CGFloat = 130.66666666666666

    let containerView: UIView = {
        let container = UIView()
        container.backgroundColor = .systemGroupedBackground
        return container
    }()

    let innerContainerView: UIView = {
        let container = UIView()
        container.backgroundColor = .none
        return container
    }()

    let inputTextView: UITextView = {
        let input = UITextView()
        input.font = UIFont.systemFont(ofSize: 16)
        input.textContainerInset.left = 8
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
        //button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()

    let separator: UIView = {
        let sep = UIView()
        sep.backgroundColor = .gray
        return sep
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .green
        
        addSubview(containerView)
                
        containerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        addSubview(separator)
        addSubview(inputTextView)
        addSubview(sendButton)
        
        containerView.easy.layout(
            Left().to(self,.left),
            Right().to(self,.right),
            Bottom().to(self,.bottom)
        )
        
        separator.easy.layout(
            Left(),
            Right(),
            Top().to(containerView,.top),
            Height(0.2)
        )
        
        inputTextView.easy.layout(
            Left(8).to(containerView,.left),
            Right().to(sendButton,.left),
            Top(8).to(containerView,.top),
            Bottom(8).to(self.safeAreaLayoutGuide,.bottom),
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
