//
//  FlickrImage.swift
//  VirtualTourist
//
//  Created by Anmol Raibhandare on 8/10/20.
//  Copyright © 2020 Anmol Raibhandare. All rights reserved.
//

import Foundation

class FlickrImage {
    
    let id: String
    let secret: String
    let server: String
    let farm: Int
    
    init(id: String, secret: String, server: String, farm: Int) {
        self.id = id
        self.secret = secret
        self.server = server
        self.farm = farm
    }
    
    func imageURL() -> String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_q.jpg"
    }
    
}
