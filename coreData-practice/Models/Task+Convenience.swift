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
    
    //computed property
    var taskRepresentation: TaskRepresentation? {
        guard let name =  self.name,
            let priority = priority else {return nil}
        
        return TaskRepresentation(name: name, notes: notes, priority: priority, identifier: identifier?.uuidString ?? "")
    }
    
    //itnitializes a task object
    convenience init(name: String, notes: String? = nil, priority: TaskPriority = .normal, identifier: UUID = UUID(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.name = name
        self.notes = notes
        self.priority = priority.rawValue  //rawvalue
        self.identifier = identifier
    }
    
    //initialize a task object from a task rep---
    convenience init?(taskRepresentation: TaskRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        // priority will have enum value
        guard let priority = TaskPriority(rawValue: taskRepresentation.priority),
            let identifier = UUID(uuidString: taskRepresentation.identifier) else { return nil}
        
        self.init(name: taskRepresentation.name,
                  notes: taskRepresentation.notes,
                  priority: priority,
                  identifier: identifier,
                  context: context)
    }
}
