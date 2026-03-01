//
//  ListContract.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 28.02.26.
//

import Combine

protocol ListViewType: AnyObject {
    func showError(message: String)
    func setSearchQuery(_ query: String)
}

protocol ListPresenting: AnyObject {
    var numberOfTasks: Int { get }
    var tasksPublisher: AnyPublisher<[TodoItem], Never> { get }
    var errorPublisher: AnyPublisher<String, Never> { get }
    func task(at index: Int) -> TodoItem?
    func viewDidLoad()
    func didSelectTask(_ task: TodoItem)
    func didTapAdd()
    func didChangeSearchQuery(_ query: String)
    func didTapComplete(_ task: TodoItem)
}

protocol ListDataProviding: AnyObject {
    func fetchTasks(completion: @escaping (Result<[TodoItem], Error>) -> Void)
    func searchTasks(query: String, completion: @escaping (Result<[TodoItem], Error>) -> Void)
    func updateTask(_ task: TodoItem, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol ListRouting: AnyObject {
    func openAddTask()
    func openTaskDetail(_ task: TodoItem)
}
