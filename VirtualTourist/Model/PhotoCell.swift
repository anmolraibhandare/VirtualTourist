//
//  PhotoCell.swift
//  VirtualTourist
//
//  Created by Anmol Raibhandare on 8/11/20.
//  Copyright © 2020 Anmol Raibhandare. All rights reserved.
//

import Foundation
import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func initPhotos(_ photo: Photo) {
        if photo.imageData != nil {
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: photo.imageData! as Data)
            }
        } else{
            downloadPhotos(photo)
        }
    }
    
    func downloadPhotos(_ photo: Photo) {
        
        URLSession.shared.dataTask(with: URL(string: photo.imageURL!)!) { (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data! as Data)
                    self.saveImage(photo: photo, imageData: data! as NSData)
                }
            }
        }
    .resume()
    }
    
    func saveImage(photo: Photo, imageData: NSData) {
        do {
            photo.imageData = imageData
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let dataController = delegate.dataController
            try dataController.saveContext()
    
        } catch {
            print("Save Failed")
        }
    }
    
    
}
