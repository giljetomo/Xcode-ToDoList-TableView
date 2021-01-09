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
    
    let newToDoItemDescription: UITextField = {
       let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "Details"
        tf.font = .systemFont(ofSize: 18)
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
        
        newToDoItem.heightAnchor.constraint(equalToConstant: 40).isActive = true
        newToDoItem.widthAnchor.constraint(lessThanOrEqualToConstant: 600).isActive = true
        newToDoItem.widthAnchor.constraint(greaterThanOrEqualToConstant: 400).isActive = true
        
        newToDoItemDescription.heightAnchor.constraint(equalToConstant: 40).isActive = true
        newToDoItemDescription.widthAnchor.constraint(lessThanOrEqualToConstant: 600).isActive = true
        newToDoItemDescription.widthAnchor.constraint(greaterThanOrEqualToConstant: 400).isActive = true
        
        let vStackView = UIStackView(arrangedSubviews: [newToDoItem, newToDoItemDescription])
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.alignment = .center
        vStackView.distribution = .equalSpacing
        vStackView.spacing = 8
        vStackView.axis = .vertical
        
        mainView.addSubview(vStackView)
        
        vStackView.widthAnchor.constraint(lessThanOrEqualTo: mainView.widthAnchor, multiplier: 0.95).isActive = true
        vStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 600).isActive = true
        vStackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10).isActive = true
        vStackView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
    
       

    }

}
