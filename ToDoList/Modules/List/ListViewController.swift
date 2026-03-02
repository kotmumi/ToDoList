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

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupBindings() {
        listView.searchQueryPublisher
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.presenter.didChangeSearchQuery(query)
            }
            .store(in: &cancellables)

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
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let task = presenter.task(at: indexPath.row) else { return }
        presenter.didSelectTask(task)
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let task = presenter.task(at: indexPath.row) else { return nil }
        return UIContextMenuConfiguration(identifier: task.id as NSString, previewProvider: nil) { [weak self] _ in
            guard let self = self else { return nil }
            let editAction = UIAction(
                title: L10n.edit,
                image: UIImage(systemName: "pencil")
            ) { _ in
                self.presenter.didSelectTask(task)
            }
            let shareAction = UIAction(
                title: L10n.share,
                image: UIImage(systemName: "square.and.arrow.up")
            ) { _ in
                self.presenter.didRequestShare(task)
            }
            let deleteAction = UIAction(
                title: L10n.delete,
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { _ in
                self.presenter.didRequestDelete(task)
            }
            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
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
        cell.onCompleteTapped = { [weak self] task in
            self?.presenter.didTapComplete(task)
        }
        return cell
    }
}

extension ListViewController: ListViewType {
    func showError(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.ok, style: .default))
        present(alert, animated: true)
    }

    func setSearchQuery(_ query: String) {
        listView.setSearchQuery(query)
    }

    func showShareSheet(for task: TodoItem) {
        let text = [task.title, task.taskDescription].filter { !$0.isEmpty }.joined(separator: "\n\n")
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activityVC, animated: true)
    }
}
