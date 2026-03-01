
//  ListView.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 28.02.26.
//

import UIKit

final class ListView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = L10n.title
        label.font = .systemFont(ofSize: FontSize.largeTitle, weight: .bold)
        label.textColor = AppColor.textPirimary
        return label
    }()
    
    private let searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.placeholder = L10n.searchPlaceholder
        return searchTextField
    }()
    
    let listTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = AppColor.backgroundPrimary
        return tableView
    }()
    
    private let tabBar = TabBarView()

    var onAddTaskTapped: (() -> Void)? {
        get { tabBar.onAddTapped }
        set { tabBar.onAddTapped = newValue }
    }

    var onSearchQueryChanged: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupSearch()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ListView {
    private func setupUI() {
        backgroundColor = AppColor.backgroundPrimary
        addSubview(titleLabel)
        addSubview(searchTextField)
        addSubview(listTableView)
        addSubview(tabBar)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Spacing.extraSmall),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.medium),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.medium),
            
            searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spacing.small),
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.medium),
            searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.medium),
            searchTextField.heightAnchor.constraint(equalToConstant: Size.primaryViewHeight),
            
            listTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: Spacing.large),
            listTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            listTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            listTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            tabBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            tabBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabBar.heightAnchor.constraint(equalToConstant: Size.tabBarHeight),
        ])
    }
    
    func config(countTask: Int) {
        tabBar.config(countTasks: countTask)
    }

    private func setupSearch() {
        searchTextField.addTarget(self, action: #selector(searchTextDidChange), for: .editingChanged)
    }

    @objc private func searchTextDidChange() {
        onSearchQueryChanged?(searchTextField.text ?? "")
    }
}
