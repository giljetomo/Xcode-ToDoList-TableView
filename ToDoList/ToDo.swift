//
//  ToDo.swift
//  ToDoList
//
//  Created by Macbook Pro on 2021-01-08.
//

import Foundation

struct Category {
    var group: Priority
    var toDos: [ToDo]
}

struct ToDo: Equatable {
    var title: String
    var todoDescription: String?
    var priority: Priority
    var isCompleted: Bool
    
    static func == (lhs: ToDo, rhs: ToDo) -> Bool {
        return lhs.title == rhs.title
    }
}

enum Priority: String {
    case high = "High Priority"
    case medium = "Medium Priority"
    case low = "Low Priority"
}
