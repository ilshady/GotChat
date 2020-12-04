//
//  Extension.swift
//  GotChat
//
//  Created by Ilshat Khairakhun on 11/23/20.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImages(urlString: String) {
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("error getting image", error!)
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    
                    if statusCode != 200 {
                        print("dataTaskWithRequest HTTP status code:", statusCode)
                    }
                } 
                DispatchQueue.main.async {
                    if let imageFromUrl = UIImage(data: data!) {
                        imageCache.setObject(imageFromUrl, forKey: urlString as NSString)
                        self.image = imageFromUrl
                    }
                }
            }.resume()
        }
    }
}
