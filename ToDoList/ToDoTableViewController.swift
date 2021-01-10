//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Gil Jetomo on 2021-01-08.
//

import UIKit

class ToDoTableViewController: UITableViewController, addViewControllerDelegate, EditVCDelegate {
    
    let cellId = "ToDo"
    
    var selectedRows: [IndexPath]?
    var toDoListIsEmpty: Bool!
    var itemForEditIndexPath: IndexPath?
    
    var toDoList: [Category] = [
        Category(group: .high, toDos: [ToDo(title: "House chore", todoDescription: "Wash the dishes", priority: .high, isCompleted: false)]),
        
        Category(group: .medium, toDos: [ToDo(title: "Exercise", todoDescription: "Walk", priority: .medium, isCompleted: true)]),
        
        Category(group: .low, toDos: [ToDo(title: "House chore", todoDescription: "Do the laundry", priority: .low, isCompleted: true), ToDo(title: "Grooming", todoDescription: "Get a haircut", priority: .low, isCompleted: true)])
    ] {
        didSet {
            //get status of the list if it is empty or not
            toDoListIsEmpty = toDoList[0].toDos.isEmpty && toDoList[1].toDos.isEmpty && toDoList[2].toDos.isEmpty
        }
    }
    
    var deleteButton: UIBarButtonItem!
    var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: self.tableView.frame, style: .insetGrouped)
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: cellId)
        
        //Navigation Controller properties
        title = "Todo Items"
        navigationController?.navigationBar.prefersLargeTitles = true
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteItem))
        navigationItem.leftBarButtonItem = editButtonItem
        
       // setEditing(false, animated: false)
        reloadNCBarButtonItems(isListEmpty: false)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        //this is the default setting in order to enter editing mode
        super.setEditing(editing, animated: animated)
        reloadNCBarButtonItems(isListEmpty: false)
    }
    
    func reloadNCBarButtonItems(isListEmpty ToDoListIsEmpty: Bool) {
        if ToDoListIsEmpty {
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItems = [addButton]
        } else if tableView.isEditing && tableView.indexPathsForSelectedRows != nil {
            navigationItem.rightBarButtonItems = [addButton, deleteButton]
        } else {
            navigationItem.leftBarButtonItem = editButtonItem
            navigationItem.rightBarButtonItems = [addButton]
        }
    }
    
    func add(_ todo: ToDo) {
        
        toDoList[1].toDos.append(todo)
        tableView.insertRows(at: [IndexPath(row: toDoList[1].toDos.count-1, section: 1)], with: .automatic)

        reloadNCBarButtonItems(isListEmpty: toDoListIsEmpty)
    }
    
    func edit(_ toDo: ToDo) {
        if let indexPath = itemForEditIndexPath {
            toDoList[indexPath.section].toDos.remove(at: indexPath.row)
            toDoList[indexPath.section].toDos.insert(toDo, at: indexPath.row)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc func deleteItem() {
        
        //read all selectedRows --> [IndexPath]
        if let selectedRows = selectedRows {
            
            //create an array of tuple that will hold the toDo item and its respective IndexPath
            var todoItems = [(IndexPath, ToDo)]()

            //iterate through the selectedRows to get all the toDo items and their respective IndexPath
            for indexPath in selectedRows {
                todoItems.append((indexPath, toDoList[indexPath.section].toDos[indexPath.row]))
            }
            
            //iterate through the array of toDoItem-and-IndexPath tuple
            for element in todoItems {
                //make an alias for IndexPath and toDoItem for each tuple for better readability (instead of processing by the tuple's index, ie. element.0-IndexPath, element.1-ToDo)
                let (indexPath, toDoItem) = element
                //remove the selected toDo item from the toDoList array/model
                toDoList[indexPath.section].toDos = toDoList[indexPath.section].toDos.filter { $0 != toDoItem }
                //reload the tableView on the specific section where the toDo item was previously located
                tableView.reloadSections([indexPath.section], with: .automatic)
            }
        }
        
       // setEditing(true, animated: false)
        reloadNCBarButtonItems(isListEmpty: toDoListIsEmpty)
    }
    
    @objc func addItem() {
      let addVC = AddViewController()
        addVC.toDoList = toDoList
        addVC.delegate = self
        navigationController?.pushViewController(addVC, animated: true)
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
        cell.accessoryType = .detailDisclosureButton
        cell.update(with: todo)
      
        //  cell.showsReorderControl = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        guard tableView.isEditing == false else { return }
        
        if !tableView.isEditing {
            tableView.deselectRow(at: indexPath, animated: true)
            
            toDoList[indexPath.section].toDos[indexPath.row].isCompleted.toggle()
            
            print(toDoList[indexPath.section].toDos[indexPath.row].todoDescription!, toDoList[indexPath.section].toDos[indexPath.row].priority)
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            if let selectedRows = tableView.indexPathsForSelectedRows {
                //get the [IndexPath] of all selected rows during edit mode
                self.selectedRows = selectedRows
                //setEditing(true, animated: false)
                reloadNCBarButtonItems(isListEmpty: false)
            }
        }
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
       
        //if a cell has been deselected, selectedRows need to be updated
        if let selectedRows = tableView.indexPathsForSelectedRows {
            //get the [IndexPath] of all selected rows during edit mode
            self.selectedRows = selectedRows
        }
        
        // setEditing(true, animated: false)
        reloadNCBarButtonItems(isListEmpty: false)
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
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let toDoItem = toDoList[indexPath.section].toDos[indexPath.row]
//        print(a.title, a.todoDescription as Any)
        
        itemForEditIndexPath = indexPath
        let editVC = EditViewController()
        editVC.toDo = toDoItem
        editVC.toDoList = toDoList
        editVC.delegate = self
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        toDoList[indexPath.section].toDos.remove(at: indexPath.row)
        tableView.reloadSections([indexPath.section], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
