//
//  MockAddEditDataProviding.swift
//  ToDoListTests
//

import Foundation
@testable import ToDoList

final class MockAddEditDataProviding: AddEditDataProviding {

    var addTaskCallCount = 0
    var addTaskLastTask: TodoItem?
    var addTaskResult: Result<Void, Error> = .success(())

    var updateTaskCallCount = 0
    var updateTaskLastTask: TodoItem?
    var updateTaskResult: Result<Void, Error> = .success(())

    func addTask(_ task: TodoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        addTaskCallCount += 1
        addTaskLastTask = task
        completion(addTaskResult)
    }

    func updateTask(_ task: TodoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        updateTaskCallCount += 1
        updateTaskLastTask = task
        completion(updateTaskResult)
    }
}
