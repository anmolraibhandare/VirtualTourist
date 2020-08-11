//
//  DataController.swift
//  VirtualTourist
//
//  Created by Anmol Raibhandare on 8/10/20.
//  Copyright © 2020 Anmol Raibhandare. All rights reserved.
//

import Foundation
import CoreData

struct DataController {
    
    // MARK: Defining a Core Data Stack
    
    internal let persistentCoordinator: NSPersistentStoreCoordinator
    private let model: NSManagedObjectModel
    private let modelURL: URL
    internal let dbURL: URL
    let context: NSManagedObjectContext

    init?(modelName: String) {
        // generating model url
        
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            print ("Unable to find model in main bundle")
            return nil
        }
        self.modelURL = modelURL

        // generating model object
        
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            print ("Unable to create model")
            return nil
        }
        self.model = model

        // creating persistent coordinator
        
        persistentCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentCoordinator

        let fileManager = FileManager.default

        guard let docURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print ("Unable to reach documents folder")
            return nil
        }

        self.dbURL = docURL.appendingPathComponent("VirtualTourist.sqlite")

        let options = [NSInferMappingModelAutomaticallyOption: true, NSMigratePersistentStoresAutomaticallyOption: true]

        do {
            try addStoreCoordinator(storeType: NSSQLiteStoreType, configuration: nil, storeURL: dbURL, options: options as [NSObject : AnyObject]?)
        } catch {
            print("Unable to add Store")
        }
    }

    func addStoreCoordinator(storeType: String, configuration: String?, storeURL: URL, options: [NSObject:AnyObject]?) throws {
        try persistentCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: dbURL, options: nil)
    }
}

// MARK: Drop all data from core data

internal extension DataController {
    func dropAllData() throws {
        try persistentCoordinator.destroyPersistentStore(at: dbURL, ofType: NSSQLiteStoreType, options: nil)
        try addStoreCoordinator(storeType: NSSQLiteStoreType, configuration: nil, storeURL: dbURL, options: nil)
    }
}

// MARK: Autosave and saving context

extension DataController{
    func autoSaveViewContext(interval:TimeInterval = 30) {
        print("autosaving")
        guard interval > 0 else {
            print("cannot set negative  autosave interval")
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }

    func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}


    
