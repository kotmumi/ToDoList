//
//  ListPresenter.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 28.02.26.
//

import Combine
import Foundation

final class ListPresenter {
    weak var view: ListViewType?
    private let interactor: ListDataProviding
    private let router: ListRouting
    
    private let tasksSubject = CurrentValueSubject<[TodoItem], Never>([])
    var tasksPublisher: AnyPublisher<[TodoItem], Never> { tasksSubject.eraseToAnyPublisher() }
    private let errorSubject = PassthroughSubject<String, Never>()
    var errorPublisher: AnyPublisher<String, Never> { errorSubject.eraseToAnyPublisher() }
    
    init(view: ListViewType? = nil, interactor: ListDataProviding, router: ListRouting) {
           self.view = view
           self.interactor = interactor
           self.router = router
       }
    
    private func userMessage(for error: Error) -> String {
        if let localizedError = error as? LocalizedError,
           let description = localizedError.errorDescription {
            return description
        } else {
            return L10n.errorUnknown
        }
    }
}

extension ListPresenter: ListPresenting {
    
    var numberOfTasks: Int {
        tasksSubject.value.count
    }
    
    func task(at index: Int) -> TodoItem? {
        let tasks = tasksSubject.value
        guard index >= 0, index < tasks.count else { return nil }
        return tasks[index]
    }
    
    func viewDidLoad() {
        interactor.fetchTasks { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tasks):
                    self?.tasksSubject.send(tasks)
                case .failure(let error):
                    self?.errorSubject.send(self?.userMessage(for: error) ?? L10n.errorUnknown)
                }
            }
        }
    }
    
    func didSelectTask(_ task: TodoItem) {
        router.openTaskDetail(task)
    }
    
    func didTapAdd() {
        router.openAddTask()
    }

    func didChangeSearchQuery(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            interactor.fetchTasks { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let tasks):
                        self?.tasksSubject.send(tasks)
                    case .failure(let error):
                        self?.errorSubject.send(self?.userMessage(for: error) ?? L10n.errorUnknown)
                    }
                }
            }
        } else {
            interactor.searchTasks(query: trimmed) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let tasks):
                        self?.tasksSubject.send(tasks)
                    case .failure(let error):
                        self?.errorSubject.send(self?.userMessage(for: error) ?? L10n.errorUnknown)
                    }
                }
            }
        }
    }

    func didTapComplete(_ task: TodoItem) {
        var updated = task
        updated.isCompleted.toggle()
        interactor.updateTask(updated) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    guard let self = self else { return }
                    var tasks = self.tasksSubject.value
                    if let index = tasks.firstIndex(where: { $0.id == updated.id }) {
                        tasks[index] = updated
                        self.tasksSubject.send(tasks)
                    }
                case .failure(let error):
                    self?.errorSubject.send(self?.userMessage(for: error) ?? L10n.errorUnknown)
                }
            }
        }
    }

    func didRequestDelete(_ task: TodoItem) {
        interactor.deleteTask(id: task.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    guard let self = self else { return }
                    var tasks = self.tasksSubject.value
                    tasks.removeAll { $0.id == task.id }
                    self.tasksSubject.send(tasks)
                case .failure(let error):
                    self?.errorSubject.send(self?.userMessage(for: error) ?? L10n.errorUnknown)
                }
            }
        }
    }

    func didRequestShare(_ task: TodoItem) {
        view?.showShareSheet(for: task)
    }
}
