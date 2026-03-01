//
//  ListViewController.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 26.02.26.
//

import UIKit
import Combine

final class ListViewController: UIViewController {

    private let presenter: ListPresenting
    private var cancellables = Set<AnyCancellable>()

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
        setupBindings()
        presenter.viewDidLoad()
    }
}

extension ListViewController {

    private func setup() {
        listView.listTableView.delegate = self
        listView.listTableView.dataSource = self
        listView.listTableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)

        listView.onAddTaskTapped = { [weak self] in
            self?.presenter.didTapAdd()
        }
        listView.onSearchQueryChanged = { [weak self] query in
            self?.presenter.didChangeSearchQuery(query)
        }
    }

    private func setupBindings() {
        presenter.tasksPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tasks in
                self?.listView.listTableView.reloadData()
                self?.listView.config(countTask: tasks.count)
            }
            .store(in: &cancellables)

        presenter.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.showError(message: message)
            }
            .store(in: &cancellables)
    }

    private func showError(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let task = presenter.task(at: indexPath.row) else { return }
        presenter.didSelectTask(task)
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
