//
//  Task+Convenience.swift
//  coreData-practice
//
//  Created by Dongwoo Pae on 7/12/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation
import CoreData

extension Task {
    convenience init(name: String, notes: String? = nil, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.name = name
        self.notes = notes
    }
}
