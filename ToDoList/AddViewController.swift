//
//  AddViewController.swift
//  ToDoList
//
//  Created by Macbook Pro on 2021-01-09.
//

import UIKit

protocol addViewControllerDelegate: class {
    func add(_ todo: ToDo)
}

class AddViewController: UIViewController {

    lazy var saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveItem))
    weak var delegate: addViewControllerDelegate?

    
    let mainView: UIView = {
        let view = UIView()
//        view.backgroundColor = .cyan
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let newToDoItem: UITextField = {
       let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "I need to..."
        tf.font = .systemFont(ofSize: 20)
        tf.heightAnchor.constraint(equalToConstant: 45).isActive = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let newToDoItemDescription: UITextField = {
       let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "Details"
        tf.font = .systemFont(ofSize: 18)
        tf.heightAnchor.constraint(equalToConstant: 45).isActive = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = saveButton
        title = "Add To Do Item"
        
        view.addSubview(mainView)
        setupLayout()
        
        newToDoItem.addTarget(self, action: #selector(textEditingChanged(_:)), for: .editingChanged)
        updateSaveButtonState()
    }
    
    @objc func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
        let newToDoItemText = newToDoItem.text ?? ""
        saveButton.isEnabled = !newToDoItemText.isEmpty
    }
    
    @objc func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveItem() {
        let newToDo = ToDo(title: newToDoItem.text!, todoDescription: newToDoItemDescription.text, priority: .medium, isCompleted: false)
        delegate?.add(newToDo)
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setupLayout() {
        mainView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1).isActive = true
        mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        mainView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1).isActive = true
        
        let vStackView = UIStackView(arrangedSubviews: [newToDoItem, newToDoItemDescription])
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.alignment = .fill
        vStackView.distribution = .fill
        vStackView.spacing = 8
        vStackView.axis = .vertical

        mainView.addSubview(vStackView)

        vStackView.widthAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 0.95).isActive = true
        vStackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10).isActive = true
        vStackView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
    }

}
