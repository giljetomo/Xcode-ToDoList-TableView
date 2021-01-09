//
//  ToDo.swift
//  ToDoList
//
//  Created by Macbook Pro on 2021-01-08.
//

import Foundation

struct ToDo {
    var title: String
    var todoDescription: String?
    var priority: Priority
    var isCompleted: Bool
}

enum Priority: String {
    case high = "High Priority"
    case medium = "Medium Priority"
    case low = "Low Priority"
}
