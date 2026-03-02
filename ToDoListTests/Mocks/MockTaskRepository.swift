//
//  MockTaskRepository.swift
//  ToDoListTests
//

import Foundation
@testable import ToDoList

final class MockTaskRepository: TaskRepository {

    var fetchAllCallCount = 0
    var fetchAllResult: Result<[TodoItem], Error> = .success([])

    var addCallCount = 0
    var addLastTask: TodoItem?
    var addResult: Result<Void, Error> = .success(())

    var addAllCallCount = 0
    var addAllLastTasks: [TodoItem]?
    var addAllResult: Result<Void, Error> = .success(())

    var updateCallCount = 0
    var updateLastTask: TodoItem?
    var updateResult: Result<Void, Error> = .success(())

    var deleteCallCount = 0
    var deleteLastId: String?
    var deleteResult: Result<Void, Error> = .success(())

    var searchCallCount = 0
    var searchLastQuery: String?
    var searchResult: Result<[TodoItem], Error> = .success([])

    func fetchAll(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        fetchAllCallCount += 1
        completion(fetchAllResult)
    }

    func add(_ task: TodoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        addCallCount += 1
        addLastTask = task
        completion(addResult)
    }

    func addAll(_ tasks: [TodoItem], completion: @escaping (Result<Void, Error>) -> Void) {
        addAllCallCount += 1
        addAllLastTasks = tasks
        completion(addAllResult)
    }

    func update(_ task: TodoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        updateCallCount += 1
        updateLastTask = task
        completion(updateResult)
    }

    func delete(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        deleteCallCount += 1
        deleteLastId = id
        completion(deleteResult)
    }

    func search(query: String, completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        searchCallCount += 1
        searchLastQuery = query
        completion(searchResult)
    }
}
