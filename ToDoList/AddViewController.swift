//
//  AddViewController.swift
//  ToDoList
//
//  Created by Macbook Pro on 2021-01-09.
//

import UIKit

class AddViewController: UIViewController {

    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let newToDoItem: UITextField = {
       let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "I need to..."
        tf.font = .systemFont(ofSize: 20)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveItem))
        title = "Add To Do Item"
        
        view.addSubview(mainView)
        setupLayout()
    }
    
    @objc func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveItem() {
        
    }
    
    func setupLayout() {
        mainView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        mainView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        mainView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1).isActive = true
        mainView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1).isActive = true
        mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        
        mainView.addSubview(newToDoItem)
        
        //added constraints so that the text field will not stretch out too much in iPad
        newToDoItem.heightAnchor.constraint(equalToConstant: 50).isActive = true
        newToDoItem.widthAnchor.constraint(lessThanOrEqualTo: mainView.widthAnchor, multiplier: 0.95).isActive = true
        newToDoItem.widthAnchor.constraint(greaterThanOrEqualToConstant: 600).isActive = true
        newToDoItem.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10).isActive = true
        newToDoItem.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true

    }

}
