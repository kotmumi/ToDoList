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
        label.textColor = AppColor.textPrimary
        label.font = .systemFont(ofSize: FontSize.body, weight: .medium)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppColor.textPrimary
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
        button.isUserInteractionEnabled = true
        return button
    }()

    var onCompleteTapped: ((TodoItem) -> Void)?

    private var currentTodoItem: TodoItem?
    
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
        completedButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        resetAppearance()
    }

    private func resetAppearance() {
        currentTodoItem = nil
        onCompleteTapped = nil
        titleLabel.attributedText = nil
        titleLabel.text = nil
        titleLabel.textColor = AppColor.textPrimary ?? .label
        descriptionLabel.text = nil
        descriptionLabel.textColor = AppColor.textPrimary ?? .label
        dateLabel.text = nil
        dateLabel.textColor = AppColor.textSecondary ?? .secondaryLabel
        completedButton.setImage(nil, for: .normal)
        completedButton.layer.borderColor = AppColor.backgroundSecondary?.cgColor
        completedButton.tintColor = AppColor.textSecondary
    }
}

extension ListTableViewCell {
    
    private func setupUI() {
        backgroundColor = AppColor.backgroundPrimary
        contentView.backgroundColor = AppColor.backgroundPrimary
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(separator)
        contentView.addSubview(completedButton)
    }

    private func setupConstraints() {
        let cv = contentView
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: cv.topAnchor, constant: Spacing.medium),
            titleLabel.leadingAnchor.constraint(equalTo: completedButton.trailingAnchor, constant: Spacing.medium),
            titleLabel.trailingAnchor.constraint(equalTo: cv.trailingAnchor, constant: -Spacing.medium),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spacing.small),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Spacing.small),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: cv.bottomAnchor, constant: -Spacing.medium),

            completedButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            completedButton.leadingAnchor.constraint(equalTo: cv.leadingAnchor, constant: Spacing.medium),
            completedButton.heightAnchor.constraint(equalToConstant: Size.checkmarkButtonSize),
            completedButton.widthAnchor.constraint(equalToConstant: Size.checkmarkButtonSize),

            separator.bottomAnchor.constraint(equalTo: cv.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: cv.leadingAnchor, constant: Spacing.medium),
            separator.trailingAnchor.constraint(equalTo: cv.trailingAnchor, constant: -Spacing.medium),
            separator.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    func config(todoItem: TodoItem) {
        resetAppearance()
        currentTodoItem = todoItem

        let textColor = todoItem.isCompleted ? (AppColor.textSecondary ?? .gray) : (AppColor.textPrimary ?? .label)
        descriptionLabel.text = todoItem.taskDescription
        descriptionLabel.textColor = textColor
        dateLabel.text = todoItem.createdAt.formatted(date: .numeric, time: .shortened).description
        dateLabel.textColor = textColor

        if todoItem.isCompleted {
            titleLabel.attributedText = NSAttributedString(
                string: todoItem.title,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: textColor
                ]
            )
            completedButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            completedButton.layer.borderColor = AppColor.accent?.cgColor
            completedButton.tintColor = AppColor.accent
        } else {
            titleLabel.text = todoItem.title
            titleLabel.textColor = textColor
            completedButton.setImage(nil, for: .normal)
            completedButton.layer.borderColor = AppColor.backgroundSecondary?.cgColor
            completedButton.tintColor = AppColor.textSecondary
        }
    }

    @objc private func completeButtonTapped() {
        guard let task = currentTodoItem else { return }
        onCompleteTapped?(task)
    }
}
