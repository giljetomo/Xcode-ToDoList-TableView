//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Macbook Pro on 2021-01-08.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    
    let cellId = "ToDo"
    
    var toDoList: [Category] = [
        Category(group: .high, toDos: [ToDo(title: "House chore", todoDescription: "Wash the dishes", priority: .high, isCompleted: false)]),
        
        Category(group: .medium, toDos: [ToDo(title: "Exercise", todoDescription: "Walk", priority: .medium, isCompleted: true)]),
        
        Category(group: .low, toDos: [ToDo(title: "House chore", todoDescription: "Do the laundry", priority: .low, isCompleted: true), ToDo(title: "Grooming", todoDescription: "Get a haircut", priority: .low, isCompleted: true)])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: self.tableView.frame, style: .insetGrouped)
        tableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: cellId)
        
        //Navigation Controller properties
        title = "Todo Items"
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        let deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [addButton, deleteButton]
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return toDoList.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return toDoList[section].group.rawValue
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 0, y: 0, width: 320, height: 30)
        myLabel.font = UIFont.boldSystemFont(ofSize: 22)
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)

        let headerView = UIView()
        headerView.addSubview(myLabel)

        return headerView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList[section].toDos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let todo = toDoList[indexPath.section].toDos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ToDoTableViewCell
        
        cell.update(with: todo)
        cell.showsReorderControl = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toDoList[indexPath.section].toDos[indexPath.row].isCompleted.toggle()
        
        print(toDoList[indexPath.section].toDos[indexPath.row].todoDescription!, toDoList[indexPath.section].toDos[indexPath.row].priority)
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        //get and remove the selected todo item from the list (model)
        var selected = toDoList[sourceIndexPath.section].toDos.remove(at: sourceIndexPath.row)
    
        //change the priority property of the todo item when moving to another section
        switch destinationIndexPath.section {
            case 0 : selected.priority = .high
            case 1 : selected.priority = .medium
            case 2 : selected.priority = .low
            default: fatalError()
        }
    
        //insert the modified todo item to the destination to update the 'model'
        toDoList[destinationIndexPath.section].toDos.insert(selected, at: destinationIndexPath.row)

    }
}
