//
//  File.swift
//  coreData-practice
//
//  Created by Dongwoo Pae on 7/16/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

struct TaskRepresentation: Codable {
    var name: String
    var notes: String?
    var priority: String
    var identifier: String     //why are we just using this as String?? UUID string property on it UUID().uuidString
}
