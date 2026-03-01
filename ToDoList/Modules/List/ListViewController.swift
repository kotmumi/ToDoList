
//  ViewController.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 26.02.26.
//

import UIKit

final class ListViewController: UIViewController {
    
    private let presenter: ListPresenting
    
    private let listView = ListView()
    
    init(presenter: ListPresenting) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = listView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}

extension ListViewController {
    
    private func setup() {
        listView.listTableView.delegate = self
        listView.listTableView.dataSource = self
        listView.listTableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        listView.config(countTask: presenter.numberOfTasks)
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfTasks
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        
        guard let todoItem = presenter.task(at: indexPath.row) else {
            return cell
        }
        
        cell.config(todoItem: todoItem)
        return cell
    }
}

extension ListViewController: ListViewType {
    
}
