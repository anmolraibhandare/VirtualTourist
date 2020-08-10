//
//  Photo+CoreDataClass.swift
//  VirtualTourist
//
//  Created by Anmol Raibhandare on 8/10/20.
//  Copyright © 2020 Anmol Raibhandare. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {
    convenience init(index: Int, imageURL: String, imageData: NSData?, context: NSManagedObjectContext){
        
        if let entity = NSEntityDescription.entity(forEntityName: "Photo", in: context){
            
            self.init(entity: entity, insertInto: context)
            self.index = Int16(index)
            self.imageURL = imageURL
            self.imageData = imageData
            
        }
        else {
            fatalError("No entity found")
        }
    }
}
