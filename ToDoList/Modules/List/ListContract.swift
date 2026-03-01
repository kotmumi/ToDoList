//
//  ListContract.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 28.02.26.
//

import Combine

protocol ListViewType: AnyObject {

}

protocol ListPresenting: AnyObject {
    var numberOfTasks: Int { get }
    var tasksPublisher: AnyPublisher<[TodoItem], Never> { get }
    var errorPublisher: AnyPublisher<String, Never> { get }
    func task(at index: Int) -> TodoItem?
    func viewDidLoad()
    func didSelectTask(_ task: TodoItem)
    func didTapAdd()
}

protocol ListDataProviding: AnyObject {
    func fetchTasks(completion: @escaping (Result<[TodoItem], Error>) -> Void)
}

protocol ListRouting: AnyObject {
    func openAddTask()
    func openTaskDetail(_ task: TodoItem)
}
