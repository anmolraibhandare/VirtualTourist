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
    internal let persistentCoordinator: NSPersistentStoreCoordinator
    private let model: NSManagedObjectModel
    private let modelURL: URL
    internal let dbURL: URL
    let context: NSManagedObjectContext

    init?(modelName: String) {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            print ("Unavle to find model in main bundle")
            return nil
        }
        self.modelURL = modelURL
       

        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            print ("Unable to create model")
            return nil
        }
        self.model = model

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

internal extension DataController {
    func dropAllData() throws {
        try persistentCoordinator.destroyPersistentStore(at: dbURL, ofType: NSSQLiteStoreType, options: nil)
        try addStoreCoordinator(storeType: NSSQLiteStoreType, configuration: nil, storeURL: dbURL, options: nil)
    }
}

extension DataController{
//    func autoSaveViewContext(interval:TimeInterval = 30) {
//        print("autosaving")
//        guard interval > 0 else {
//            print("cannot set negative  autosave interval")
//            return
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
//            self.autoSaveViewContext(interval: interval)
//        }
//    }
    func autoSave(_ delayInSeconds : Int) {
        
        if delayInSeconds > 0 {
            
            do {
                
                try saveContext()
                print("Autosaving")
                
            } catch {
                
                print("Error While Autosaving")
            }
            
            let delayInNanoSeconds = UInt64(delayInSeconds) * NSEC_PER_SEC
            let time = DispatchTime.now() + Double(Int64(delayInNanoSeconds)) / Double(NSEC_PER_SEC)
            
            DispatchQueue.main.asyncAfter(deadline: time) {
                
                self.autoSave(delayInSeconds)
            }
        }
    }
    func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}


    
