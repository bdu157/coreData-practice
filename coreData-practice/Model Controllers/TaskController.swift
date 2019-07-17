//
//  TaskController.swift
//  coreData-practice
//
//  Created by Dongwoo Pae on 7/16/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://task-coredata.firebaseio.com/")!

class TaskController {
    
    typealias CompletionHandler = (Error?) -> Void
    
    init() {
        fetchTaskFromServer()
    }
    
    //Fetch the Tasks from the server
    func fetchTaskFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching tasks: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned by the data task")
                completion(NSError())
                return
            }
            
            do {
                let taskRepresentations = Array(try JSONDecoder().decode([String: TaskRepresentation].self, from: data).values)
                try self.updateTasks(with: taskRepresentations)
                completion(nil)
            } catch {
                NSLog("Error decoding task representation: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    private func updateTasks(with representations: [TaskRepresentation]) throws {
        for taskRep in representations {
            guard let uuid = UUID(uuidString: taskRep.identifier) else {continue}
            
            let task = self.task(forUUID: uuid)  //this will return either nil or a value
            
            if let task = task {
                self.update(task: task, with: taskRep)
            } else {
                let _ = Task(taskRepresentation: taskRep)  //taskRep is one library from array of representation library which is equal to TaskRepresentation struct
            }
        }
        try self.saveToPersistentStore()
    }
    
    //Get task from UUID
    private func task(forUUID uuid: UUID) -> Task? {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", uuid as NSUUID)
        
        do {
            let moc = CoreDataStack.shared.mainContext
            return try moc.fetch(fetchRequest).first // array of task but we want just one task
        } catch {
            NSLog("Error fetching task with uuid \(uuid): \(error)")
            return nil
        }
    }
    
    //Update task with task Representation from Server
    private func update(task: Task, with representation: TaskRepresentation) {
        task.name = representation.name
        task.notes = representation.notes
        task.priority = representation.priority
    }

    //PUT Request
    func put(task: Task, completion: @escaping CompletionHandler = { _ in }) {
        
        let uuid = task.identifier ?? UUID()
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = task.taskRepresentation else {
                completion(NSError())
                return
            }
            representation.identifier = uuid.uuidString
            task.identifier = uuid
            try saveToPersistentStore()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding task \(task):\(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error PUTing task to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    //DELETE method
    func delete(_ task:Task, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = task.identifier else {
            completion(NSError())
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            print(response!)
            completion(error)
        }.resume()
    }
    
    func saveToPersistentStore() throws {
        let moc = CoreDataStack.shared.mainContext
        try moc.save()
    }
}
