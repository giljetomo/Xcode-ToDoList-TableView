//
//  ToDoTableViewCell.swift
//  ToDoList
//
//  Created by Macbook Pro on 2021-01-08.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    let titleLabel: UILabel = {
       let lb = UILabel()
        lb.font = .systemFont(ofSize: 22)
        return lb
    }()
    
    let todoDescriptionLabel: UILabel = {
        let lb = UILabel()
         return lb
     }()
    
    let isCompletedLabel: UILabel = {
        let lb = UILabel()
        lb.setContentHuggingPriority(.required, for: .horizontal)
        return lb
    }()
    
//    let editButton: UIButton = {
//        let eb = UIButton(type: .detailDisclosure)
//        eb.constraintHeight(equalToConstant: 50)
//        eb.translatesAutoresizingMaskIntoConstraints = false
//        return eb
//    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let vStackView = UIStackView(arrangedSubviews: [titleLabel, todoDescriptionLabel])
        vStackView.axis = .vertical
        vStackView.alignment = .fill
        vStackView.distribution = .fill
        vStackView.spacing = 0
        
        
        let hStackView = UIStackView(arrangedSubviews: [isCompletedLabel, vStackView])
        hStackView.axis = .horizontal
        hStackView.alignment = .fill
        hStackView.distribution = .fill
        hStackView.spacing = 8
        
        contentView.addSubview(hStackView)
        hStackView.matchParent(padding: .init(top: 5, left: 5, bottom: 5, right: 8))

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with todo: ToDo) {
      titleLabel.text = todo.title
      todoDescriptionLabel.text = todo.todoDescription
      isCompletedLabel.text = todo.isCompleted ? "☑️" : ""
    }
}
