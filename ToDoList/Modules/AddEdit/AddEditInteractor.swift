//
//  AddEditInteractor.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 1.03.26.
//

import Foundation

final class AddEditInteractor: AddEditDataProviding {

    private let repository: TaskRepository

    init(repository: TaskRepository) {
        self.repository = repository
    }

    func addTask(_ task: TodoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.add(task, completion: completion)
    }

    func updateTask(_ task: TodoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.update(task, completion: completion)
    }
}
