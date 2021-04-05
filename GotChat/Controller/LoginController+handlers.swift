//
//  LoginController+handlers.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 11/23/20.
//

import UIKit
import Firebase
import MBProgressHUD

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleProfileImageSelect() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true) {}
        picker.modalPresentationStyle = .fullScreen
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let newImage: UIImage
        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        loginView.profileImage.image = newImage
        picker.dismiss(animated: true, completion: nil)
    }
    

}
