//
//  ChatMessageCellCollectionViewCell.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 06.01.2021.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    let textView: UITextView = {
        let text = UITextView()
        text.text = "temp"
        text.font = UIFont.systemFont(ofSize: 16)
        text.backgroundColor = .red
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textView)
        
        [
            textView.rightAnchor.constraint(equalTo: self.rightAnchor),
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.widthAnchor.constraint(equalToConstant: 100),
            textView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ].forEach({$0.isActive = true})
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
