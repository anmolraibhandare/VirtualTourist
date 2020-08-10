//
//  FlickrAPI.swift
//  VirtualTourist
//
//  Created by Anmol Raibhandare on 8/10/20.
//  Copyright © 2020 Anmol Raibhandare. All rights reserved.
//

import Foundation
import UIKit

class FlickrAPI {
    private static let flickrAPI = "f3ecba0995f5bc39006ff73104552109"
    private static let flickrEndpoint = "https://api.flickr.com/services/rest/"
    private static let flickrSearch = "flickr.photos.search"
    private static let flickrFormat = "json"
    private static let flickrRange = 10
    
    static func getImage(latitude: Double, longitude: Double, completion: @escaping ( _ sucess:Bool, _ flickrImage: [FlickrImage]?) -> Void){
        let url = NSMutableURLRequest(url: URL(string: "\(flickrEndpoint)?method=\(flickrSearch)&format=\(flickrFormat)&api_key=\(flickrAPI)&lat=\(latitude)&lon=\(longitude)&radius=\(flickrRange)")!)
        let task = URLSession.shared.dataTask(with: url as URLRequest) { data, response, error in
            
            if error != nil {
                completion(false, nil)
                return
            }
            
            let range = Range<Int>(uncheckedBounds: (lower: 14, upper: data!.count-1))
            let newData = data?.subdata(in: range)
            
            if let json = try? JSONSerialization.jsonObject(with: newData!) as? [String:Any],
                let photosTemp = json["photos"] as? [String:Any],
                let photos = photosTemp["photo"] as? [Any]{
                
                var flickrImages: [FlickrImage] = []
                
                for photo in photos {
                    
                    if let flickrImage = photo as? [String:Any],
                        let id = flickrImage["id"] as? String,
                        let secret = flickrImage["secret"] as? String,
                        let server = flickrImage["server"] as? String,
                        let farm = flickrImage["farm"] as? Int{
                        
                        flickrImages.append(FlickrImage(id: id, secret: secret, server: server, farm: farm))
                    }
                }
                completion(true, flickrImages)
            } else {
                completion(false, nil)
            }

        }
        task.resume()
    }
    
}
