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
                    self?.errorSubject.send(error.localizedDescription)
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
}
