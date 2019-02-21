//
//  CustomImageView.swift
//  Instagram
//
//  Created by Fahad Almehawas on 5/12/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//
//

import UIKit

var imageCache = [String: UIImage]()

import UIKit
class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        
        lastURLUsedToLoadImage = urlString
        
        self.image = nil
        
        //effiecient image caching
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else {return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("failed to fetch image:", err)
                return
            }
            
            
            //prevents the images from l.oading incorrectly
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
            
            guard let imageData = data else {return}
            
            let photoImage = UIImage(data: imageData)
            
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
            
            }.resume()
        
    }
}
