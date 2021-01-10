//
//  EditViewController.swift
//  ToDoList
//
//  Created by Macbook Pro on 2021-01-10.
//

import UIKit

protocol EditVCDelegate: class {
    func edit(_ toDo: ToDo)
}

class EditViewController: UIViewController {

    var toDo: ToDo?
    var delegate: EditVCDelegate?
    
    let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveItem))
    
    let mainView: UIView = {
        let mv = UIView()
        mv.backgroundColor = .white
        mv.translatesAutoresizingMaskIntoConstraints = false
        return mv
    }()
    
    let toDoItemTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "I need to..."
        tf.font = .systemFont(ofSize: 20)
        tf.heightAnchor.constraint(equalToConstant: 45).isActive = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let toDoItemDetailsTextField: UITextField = {
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
        view.backgroundColor = .systemBackground
        title = "Edit Todo Item"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = saveButton
        view.addSubview(mainView)
        
        toDoItemTextField.text = toDo?.title
        toDoItemDetailsTextField.text = toDo?.todoDescription
        toDoItemTextField.becomeFirstResponder()
        
        toDoItemTextField.addTarget(self, action: #selector(textEditingChanged(_:)), for: .editingChanged)
    
        setupLayout()
    }
    
    @objc func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
        let toDoItem = toDoItemTextField.text ?? ""
        saveButton.isEnabled = !toDoItem.isEmpty
    }
    
    @objc func saveItem() {
        let toDoItem = ToDo(title: toDoItemTextField.text!, todoDescription: toDoItemDetailsTextField.text!, priority: toDo!.priority, isCompleted: toDo!.isCompleted)
        delegate?.edit(toDoItem)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func dismissView() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setupLayout() {
        mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        mainView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1).isActive = true
        mainView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1).isActive = true
        
        let vStackView = UIStackView(arrangedSubviews: [toDoItemTextField, toDoItemDetailsTextField])
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.axis = .vertical
        vStackView.distribution = .fill
        vStackView.alignment = .fill
        vStackView.spacing = 8
        
        view.addSubview(vStackView)
        
        vStackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10).isActive = true
        vStackView.widthAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 0.95).isActive = true
        vStackView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
    }
}
