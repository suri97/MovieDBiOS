//
//  ImageCaching.swift
//  MDB
//
//  Created by Suruchi Chopra on 11/01/18.
//  Copyright © 2018 Suransh Chopra. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageIntoCacheFromUrl (imageURL: URL) {
        
        self.image = nil
        
        if let downloadedImage = imageCache.object(forKey: imageURL.absoluteString as AnyObject ) as? UIImage {
            self.image = downloadedImage
        }
        else {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.image = image
                        imageCache.setObject(image!, forKey: imageURL.absoluteString as AnyObject)
                    }
                }
            }
        }
    }
    
}
