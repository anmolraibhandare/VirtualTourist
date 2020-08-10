//
//  Pin+CoreDataClass.swift
//  VirtualTourist
//
//  Created by Anmol Raibhandare on 8/10/20.
//  Copyright © 2020 Anmol Raibhandare. All rights reserved.
//
//

import Foundation
import CoreData


public class Pin: NSManagedObject {
    convenience init(latitude: Double, longitude: Double, context: NSManagedObjectContext){
        if let entity = NSEntityDescription.entity(forEntityName: "Pin", in: context){
            self.init(entity: entity, insertInto: context)
            self.longitude = longitude
            self.latitude = latitude
        } else {
            fatalError("No entity found")
        }
    }
}
