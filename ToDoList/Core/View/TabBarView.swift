//
//  TabBarView.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 28.02.26.
//

import UIKit

final class TabBarView: UIView {
    
    private let countTasksLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: FontSize.caption, weight: .regular)
        label.textColor = AppColor.textPirimary
        label.text = L10n.countTasks
        return label
    }()
    
    private let addTaskButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: Size.imageSize , weight: .medium)
            let image = UIImage(systemName: "square.and.pencil", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = AppColor.accent
        return button
    }()

    var onAddTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TabBarView {
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = AppColor.backgroundSecondary
        addSubview(countTasksLabel)
        addSubview(addTaskButton)
        addTaskButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }

    @objc private func addButtonTapped() {
        onAddTapped?()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            countTasksLabel.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.medium),
            countTasksLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            addTaskButton.centerYAnchor.constraint(equalTo: countTasksLabel.centerYAnchor),
            addTaskButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.medium),
            addTaskButton.heightAnchor.constraint(equalToConstant: Size.primaryViewHeight),
            addTaskButton.widthAnchor.constraint(equalToConstant: Size.primaryViewHeight)
        ])
    }
    
    func config(countTasks: Int) {
        countTasksLabel.text = "\(countTasks) \(L10n.countTasks)"
    }
}
