//
//  AddEditInteractorTests.swift
//  ToDoListTests
//

import XCTest
@testable import ToDoList

final class AddEditInteractorTests: XCTestCase {

    var mockRepository: MockTaskRepository!
    var sut: AddEditInteractor!

    override func setUp() {
        super.setUp()
        mockRepository = MockTaskRepository()
        sut = AddEditInteractor(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func test_addTask_callsRepositoryAdd() {
        let task = TodoItem(id: "1", title: "T", taskDescription: "D", createdAt: Date(), isCompleted: false)
        let exp = expectation(description: "completion")

        sut.addTask(task) { _ in exp.fulfill() }

        wait(for: [exp], timeout: 1)
        XCTAssertEqual(mockRepository.addCallCount, 1)
        XCTAssertEqual(mockRepository.addLastTask?.id, "1")
        XCTAssertEqual(mockRepository.addLastTask?.title, "T")
    }

    func test_updateTask_callsRepositoryUpdate() {
        let task = TodoItem(id: "2", title: "Updated", taskDescription: "Desc", createdAt: Date(), isCompleted: true)
        let exp = expectation(description: "completion")

        sut.updateTask(task) { _ in exp.fulfill() }

        wait(for: [exp], timeout: 1)
        XCTAssertEqual(mockRepository.updateCallCount, 1)
        XCTAssertEqual(mockRepository.updateLastTask?.id, "2")
        XCTAssertEqual(mockRepository.updateLastTask?.title, "Updated")
    }
}
