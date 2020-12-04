//
//  LoginControllerViewController.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 11/11/20.
//

import UIKit

class LoginViewController: UIViewController {
    
    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
    }
    
    func setupInputConrainerView() {
        view.addSubview(inputContainerView)
    }

}
extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}
