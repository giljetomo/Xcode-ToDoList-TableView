//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Gil Jetomo on 2021-01-08.
//

import UIKit

class ToDoTableViewController: UITableViewController, addViewControllerDelegate, EditVCDelegate, addEditViewControllerDelegate {
    
    let cellId = "ToDo"
    
    //for storing the selected toDo item/s
    var selectedRows: [IndexPath]?
    
    //for observing toDoList contents
    var toDoListIsEmpty: Bool!
    
    //for storing the selected toDo item when detailDisclosureButton in a cell is selected
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
    //Navigation Controller's right rightBarButtonItems
    var deleteButton: UIBarButtonItem!
    var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //optional but implemented to customize the tableView's style to insetGrouped
        self.tableView = UITableView(frame: self.tableView.frame, style: .insetGrouped)
        //allows multiple selection during edit mode
        tableView.allowsMultipleSelectionDuringEditing = true
        //register custom ToDoTableViewCell
        tableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: cellId)
        
        //Navigation Controller properties
        title = "Todo Items"
        navigationController?.navigationBar.prefersLargeTitles = true
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteItem))
        
        reloadNCBarButtonItems(isListEmpty: false)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        //this is the default setting in order to enter editing mode
        super.setEditing(editing, animated: animated)
        
        if let _ = toDoListIsEmpty {
            reloadNCBarButtonItems(isListEmpty: toDoListIsEmpty)
        } else {
            reloadNCBarButtonItems()
        }
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
    
    func reloadNCBarButtonItems() {
        navigationItem.rightBarButtonItems = [addButton, deleteButton]
        navigationItem.leftBarButtonItem = editButtonItem
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
    
    @objc func addItem() {
//      let addVC = AddViewController()
//        addVC.toDoList = toDoList
//        addVC.delegate = self
//        navigationController?.pushViewController(addVC, animated: true)
        let addVC = AddEditViewController()
        addVC.addEditDelegate = self
        addVC.toDoList = toDoList
        
        navigationController?.pushViewController(addVC, animated: true)
    }
    
    @objc func deleteItem() {
        
        //read all selectedRows --> [IndexPath]
        if let selectedRows = selectedRows {
            
            //create an empty array of tuple that will hold the toDo item and its respective IndexPath
            var todoItems = [(IndexPath, ToDo)]()

            //iterate through the selectedRows to get all the toDo items and their respective IndexPath
            for indexPath in selectedRows {
                //insert the selected toDo items on their respective group/section (based on priority) into todoItems tuple-array
                todoItems.append((indexPath, toDoList[indexPath.section].toDos[indexPath.row]))
            }
            
            //iterate through the then-populated array of toDoItem-and-IndexPath tuple and read each toDo item to be deleted
            for element in todoItems {
                //make an alias for the IndexPath and toDoItem on each tuple for better readability (instead of processing by the tuple's index, ie. element.0 = IndexPath, element.1 = ToDo)
                let (indexPath, toDoItem) = element
                //update the toDoList array/model by removing the selected toDo item
                toDoList[indexPath.section].toDos = toDoList[indexPath.section].toDos.filter { $0 != toDoItem }
                //reload the tableView on the specific section where the toDo item was previously located
                tableView.reloadSections([indexPath.section], with: .automatic)
                
//                tableView.insertRows(at: [IndexPath(row: toDoList[1].toDos.count-1, section: 1)], with: .automatic)
//                while let a = tableView.indexPathsForSelectedRows, !a.isEmpty {
//                    print(a)
//                    for indexPath in stride(from: a.count-1, through: 0, by: -1) {
//                        print(indexPath)
//                        tableView.deleteRows(at: [a[indexPath]], with: .automatic)
//                        tableView.reloadSections([a[indexPath].section], with: .automatic)
//                        break
//                    }
//                }
            }
        }

        reloadNCBarButtonItems(isListEmpty: toDoListIsEmpty)
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
    
    //customizes the section headers
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: .zero, y: .zero, width: tableView.frame.width, height: 30)
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
        
        if !tableView.isEditing {
            //flip the isCompleted property of the selected toDo item
            toDoList[indexPath.section].toDos[indexPath.row].isCompleted.toggle()
            
            print(toDoList[indexPath.section].toDos[indexPath.row].priority.rawValue.trimmingCharacters(in: CharacterSet(charactersIn: " Priority")).uppercased(), toDoList[indexPath.section].toDos[indexPath.row].title, toDoList[indexPath.section].toDos[indexPath.row].todoDescription!)
            //reload the cell of selected toDo item to reflect its updated isCompleted property
            tableView.reloadRows(at: [indexPath], with: .fade)
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

        reloadNCBarButtonItems(isListEmpty: false)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        //if any item is currently selected and has been moved, its respective IndexPath will be collected
        if let selectedRows = tableView.indexPathsForSelectedRows {
            //get the [IndexPath] of all selected rows during edit mode
            self.selectedRows = selectedRows
            print(selectedRows)
        }
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
        //get the selected toDo item when the cell's accessory button is tapped for editing
        let toDoItem = toDoList[indexPath.section].toDos[indexPath.row]
        //get the toDo item's indexPath to be used later for saving the updated toDo item in its proper location
        itemForEditIndexPath = indexPath
        
//        let editVC = EditViewController()
//        //pass the selected toDo item to EditViewController
//        editVC.toDo = toDoItem
//        //pass the toDo list to EditViewController
//        editVC.toDoList = toDoList
//        //assign ToDoTableViewController to be EditViewController's delegate
//        editVC.delegate = self
//        navigationController?.pushViewController(editVC, animated: true)
        
        let editVC = AddEditViewController()
        editVC.toDo = toDoItem
        editVC.toDoList = toDoList
        editVC.inEditMode = true
        editVC.addEditDelegate = self
        
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    //function needed to enable swipe delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        toDoList[indexPath.section].toDos.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    //function needed to enable swipe delete
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
