//
//  MockListDataProviding.swift
//  ToDoListTests
//

import Foundation
@testable import ToDoList

final class MockListDataProviding: ListDataProviding {

    var fetchTasksCallCount = 0
    var fetchTasksResult: Result<[TodoItem], Error> = .success([])

    var searchTasksCallCount = 0
    var searchTasksQuery: String?
    var searchTasksResult: Result<[TodoItem], Error> = .success([])

    var updateTaskCallCount = 0
    var updateTaskLastTask: TodoItem?
    var updateTaskResult: Result<Void, Error> = .success(())

    var deleteTaskCallCount = 0
    var deleteTaskLastId: String?
    var deleteTaskResult: Result<Void, Error> = .success(())

    func fetchTasks(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        fetchTasksCallCount += 1
        DispatchQueue.main.async { completion(self.fetchTasksResult) }
    }

    func searchTasks(query: String, completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        searchTasksCallCount += 1
        searchTasksQuery = query
        DispatchQueue.main.async { completion(self.searchTasksResult) }
    }

    func updateTask(_ task: TodoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        updateTaskCallCount += 1
        updateTaskLastTask = task
        DispatchQueue.main.async { completion(self.updateTaskResult) }
    }

    func deleteTask(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        deleteTaskCallCount += 1
        deleteTaskLastId = id
        DispatchQueue.main.async { completion(self.deleteTaskResult) }
    }
}
