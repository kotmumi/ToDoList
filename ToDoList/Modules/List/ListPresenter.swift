//
//  ListPresenter.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 28.02.26.
//

import Combine

final class ListPresenter {
    weak var view: ListViewType?
    private let interactor: ListDataProviding
    private let router: ListRouting
    
    private let tasksSubject = CurrentValueSubject<[TodoItem], Never>([])
    var tasksPublisher: AnyPublisher<[TodoItem], Never> { tasksSubject.eraseToAnyPublisher() }
    private let errorSubject = PassthroughSubject<String, Never>()
    var errorPublisher: AnyPublisher<String, Never> { errorSubject.eraseToAnyPublisher() }
    
    init(view: ListViewType?, interactor: ListDataProviding, router: ListRouting) {
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
        
    }
    
    func didSelectTask(_ task: TodoItem) {
        
    }
    
    func didTapAdd() {
        
    }
}
