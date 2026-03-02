//
//  MockTodosFetching.swift
//  ToDoListTests
//

import Foundation
@testable import ToDoList

final class MockTodosFetching: TodosFetching {

    var fetchTodosCallCount = 0
    var fetchTodosResult: Result<[TodoItem], Error> = .success([])

    func fetchTodos(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        fetchTodosCallCount += 1
        completion(fetchTodosResult)
    }
}
