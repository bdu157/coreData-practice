//
//  Task+Convenience.swift
//  coreData-practice
//
//  Created by Dongwoo Pae on 7/12/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation
import CoreData

enum TaskPriority: String, CaseIterable {
    case low
    case normal
    case high
    case critical
    
//    static var allPriorities: [TaskPriority] {
//        return [.low, .normal, .high, .critical]
//    }
}

extension Task {
    convenience init(name: String, notes: String? = nil, priority: TaskPriority = .normal, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.name = name
        self.notes = notes
        self.priority = priority.rawValue  //rawvalue
    }
}
