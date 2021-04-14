//
//  MessagesCollectionView.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 05.04.2021.
//

import UIKit
import EasyPeasy

class MessagesCollectionView: UICollectionView {
    
    let cellId = "cellId"
    lazy var inputContainerView = ChatInputContainerView()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        super.backgroundColor = .black
        
        addSubview(inputContainerView)
        
        inputContainerView.easy.layout(
            CenterX(),
            Bottom().to(self,.bottom),
            Width().like(self,.width)
        )
        
        register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 20, right: 0)
        scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        backgroundColor = .white
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
