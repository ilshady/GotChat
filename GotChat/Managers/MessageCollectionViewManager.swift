//
//  MessageCollectionViewManager.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 13.04.2021.
//

import UIKit

class MessageCollectionViewManager: NSObject, UICollectionViewDataSource {
    
    let cellId = "cellId"
    var messages = [Message]()
    lazy var inputContainerView = ChatInputContainerView()
    var outerView = UIView()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        return cell
    }
}

extension MessageCollectionViewManager: UICollectionViewDelegateFlowLayout {
    
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
        let text = messages[indexPath.item].text
        height = estimateFrameForText(text).height + 20
        return CGSize(width: outerView.frame.width, height: height)
    }
}
