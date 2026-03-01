//
//  TaskRepository.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 1.03.26.
//

protocol TaskRepository: AnyObject {
    func fetchAll(completion: @escaping (Result<[TodoItem], Error>) -> Void)
    func add(_ task: TodoItem, completion: @escaping (Result<Void, Error>) -> Void)
    func update(_ task: TodoItem, completion: @escaping (Result<Void, Error>) -> Void)
    func delete(id: String, completion: @escaping (Result<Void, Error>) -> Void)
    func search(query: String, completion: @escaping (Result<[TodoItem], Error>) -> Void)
}
