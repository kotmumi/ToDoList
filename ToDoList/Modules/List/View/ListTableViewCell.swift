//
//  ListTableViewCell.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 28.02.26.
//

import UIKit

final class ListTableViewCell: UITableViewCell {
    
    static let identifier: String = String(describing: ListTableViewCell.self) 
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppColor.textPirimary
        label.font = .systemFont(ofSize: FontSize.body, weight: .medium)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppColor.textPirimary
        label.font = .systemFont(ofSize: FontSize.caption, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppColor.textSecondary
        label.font = .systemFont(ofSize: FontSize.caption, weight: .regular)
        return label
    }()
    
    private let completedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Size.cornerRadiusLarge
        button.layer.borderWidth = 1
        button.layer.borderColor = AppColor.backgroundSecondary?.cgColor
        return button
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColor.backgroundSecondary?.cgColor
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ListTableViewCell {
    
    private func setupUI() {
        backgroundColor = AppColor.backgroundPrimary
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(dateLabel)
        addSubview(completedButton)
        addSubview(separator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.medium),
            titleLabel.leadingAnchor.constraint(equalTo: completedButton.trailingAnchor, constant: Spacing.medium),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.medium),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spacing.small),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Spacing.small),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.medium),
            
            completedButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            completedButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.medium),
            completedButton.heightAnchor.constraint(equalToConstant: Size.checkmarkButtonSize),
            completedButton.widthAnchor.constraint(equalToConstant: Size.checkmarkButtonSize),
            
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.medium),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.medium),
            separator.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    func config(todoItem: TodoItem) {
        titleLabel.text = "\(todoItem.title)"
        descriptionLabel.text = "\(todoItem.taskDescription)"
        dateLabel.text = todoItem.createdAt.formatted(date: .numeric, time: .shortened).description
        if todoItem.isCompleted {
            completedButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            completedButton.layer.borderColor = AppColor.accent?.cgColor
            completedButton.tintColor = AppColor.accent
        }
    }
}
