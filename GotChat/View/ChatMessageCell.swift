//
//  ChatMessageCellCollectionViewCell.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 06.01.2021.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    
    let textView: UILabel = {
        let text = UILabel()
        text.text = "temp"
        text.font = UIFont.systemFont(ofSize: 16)
        text.backgroundColor = .clear
        text.textColor = .white
        text.numberOfLines = 0
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 0, g: 137, b: 249)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        view.layer.borderWidth = 0.2
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
    
    var bubleWidthAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textView)
        
        
        [
            bubbleView.topAnchor.constraint(equalTo: textView.topAnchor, constant: -5),
            bubbleView.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: 5),
            bubbleView.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: -9),
            bubbleView.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 9),
            
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            textView.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        ].forEach({$0.isActive = true})
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
