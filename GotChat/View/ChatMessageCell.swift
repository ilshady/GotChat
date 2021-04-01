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
        view.backgroundColor = #colorLiteral(red: 0, green: 0.537254902, blue: 0.9764705882, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.borderWidth = 0.2
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textView)
        
        [
            bubbleView.topAnchor.constraint(equalTo: textView.topAnchor),
            bubbleView.bottomAnchor.constraint(equalTo: textView.bottomAnchor),
            bubbleView.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: -9),
            bubbleView.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 9),
            
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
            textView.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        ].forEach({$0.isActive = true})
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
