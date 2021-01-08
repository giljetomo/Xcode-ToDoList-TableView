//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Macbook Pro on 2021-01-08.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    
    let cellId = "ToDo"
    
    var toDoList: [[ToDo]] = [
        [ToDo(title: "House chore", todoDescription: "Wash the dishes", priority: 1, isCompleted: false)],
        [ToDo(title: "Exercise", todoDescription: "Walk", priority: 2, isCompleted: true)],
        [ToDo(title: "House chore", todoDescription: "Do the laundry", priority: 3, isCompleted: false)]
    ]
    
    var sectionTitles: [String] = ["High Priority", "Medium Priority", "Low Priority"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: cellId)
        title = "Todo Items"
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        let deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [addButton, deleteButton]
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let todo = toDoList[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ToDoTableViewCell
        
        cell.update(with: todo)
        cell.showsReorderControl = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selected = toDoList.remove(at: [indexPath.section][indexPath.row])
        selected[0].isCompleted = !selected[0].isCompleted
        toDoList.insert(selected, at: [indexPath.section][indexPath.row])
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let selected = toDoList.remove(at: sourceIndexPath.row)
        toDoList.insert(selected, at: destinationIndexPath.row
        )
    }


}
