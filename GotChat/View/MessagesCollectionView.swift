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
    lazy var messageViewModel = MessageViewModel()
    lazy var inputContainerView = ChatInputContainerView()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        delegate = self
        dataSource = self
        
        addSubview(inputContainerView)
        
        inputContainerView.easy.layout(
            CenterX(),
            Bottom().to(self,.bottom),
            Width().like(self,.width)
        )
        
        register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        backgroundColor = .white

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension MessagesCollectionView: UICollectionViewDelegateFlowLayout {
    
    private func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputContainerView.inputTextView.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        let text = messageViewModel.messages[indexPath.item].text
        height = estimateFrameForText(text).height + 20
        return CGSize(width: self.frame.width, height: height)
    }
}

extension MessagesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return messageViewModel.messages.count
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messageViewModel.messages[indexPath.item]
        cell.textView.text = message.text
        return cell
    }
}
