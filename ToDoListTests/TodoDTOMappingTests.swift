//
//  TodoDTOMappingTests.swift
//  ToDoListTests
//

import XCTest
@testable import ToDoList

@MainActor
final class TodoDTOMappingTests: XCTestCase {

    func test_toDomain_mapsDTOToTodoItem() {
        let dto = TodoDTO(id: 42, todo: "Buy milk", completed: true, userId: 1)
        let item = dto.toDomain()

        XCTAssertEqual(item.id, "42")
        XCTAssertEqual(item.title, "Buy milk")
        XCTAssertEqual(item.taskDescription, "")
        XCTAssertTrue(item.isCompleted)
    }

    func test_toDomain_mapsUncompleted() {
        let dto = TodoDTO(id: 1, todo: "Task", completed: false, userId: 2)
        let item = dto.toDomain()

        XCTAssertFalse(item.isCompleted)
    }

    func test_TodosResponse_decodesValidJSON() throws {
        let json = """
        {"todos":[{"id":1,"todo":"First","completed":false,"userId":1}],"total":1,"skip":0,"limit":10}
        """
        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(TodosResponse.self, from: data)

        XCTAssertEqual(response.todos.count, 1)
        XCTAssertEqual(response.todos[0].id, 1)
        XCTAssertEqual(response.todos[0].todo, "First")
        XCTAssertEqual(response.total, 1)
    }
}
