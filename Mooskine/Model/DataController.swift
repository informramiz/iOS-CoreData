//
//  DataController.swift
//  Mooskine
//
//  Created by Ramiz Raja on 28/08/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    let persistenceContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistenceContainer.viewContext
    }
    
    init(modelName: String) {
        persistenceContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistenceContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
}
