//
//  ListContract.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 28.02.26.
//

protocol ListViewType: AnyObject {

}

protocol ListPresenting: AnyObject {
    var numberOfTasks: Int { get }
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
