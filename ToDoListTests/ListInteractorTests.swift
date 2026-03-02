//
//  ListInteractorTests.swift
//  ToDoListTests
//

import XCTest
@testable import ToDoList

private let hasLoadedKey = "hasLoadedTodosFromAPI"

final class ListInteractorTests: XCTestCase {

    var mockRepository: MockTaskRepository!
    var mockAPI: MockTodosFetching!
    var sut: ListInteractor!

    override func setUp() {
        super.setUp()
        mockRepository = MockTaskRepository()
        mockAPI = MockTodosFetching()
        sut = ListInteractor(repository: mockRepository, apiService: mockAPI)
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: hasLoadedKey)
        sut = nil
        mockAPI = nil
        mockRepository = nil
        super.tearDown()
    }

    func test_fetchTasks_firstLaunch_callsAPIAndSaves() {
        UserDefaults.standard.set(false, forKey: hasLoadedKey)
        let items = [TodoItem(id: "1", title: "A", taskDescription: "", createdAt: Date(), isCompleted: false)]
        mockAPI.fetchTodosResult = .success(items)
        mockRepository.addAllResult = .success(())
        mockRepository.fetchAllResult = .success(items)

        let exp = expectation(description: "fetch")
        sut.fetchTasks { result in
            if case .success(let tasks) = result { XCTAssertEqual(tasks.count, 1) }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)

        XCTAssertEqual(mockAPI.fetchTodosCallCount, 1)
        XCTAssertEqual(mockRepository.addAllCallCount, 1)
        XCTAssertEqual(mockRepository.fetchAllCallCount, 1)
        XCTAssertTrue(UserDefaults.standard.bool(forKey: hasLoadedKey))
    }

    func test_fetchTasks_notFirstLaunch_usesRepositoryOnly() {
        UserDefaults.standard.set(true, forKey: hasLoadedKey)
        let items = [TodoItem(id: "2", title: "B", taskDescription: "", createdAt: Date(), isCompleted: true)]
        mockRepository.fetchAllResult = .success(items)

        let exp = expectation(description: "fetch")
        sut.fetchTasks { result in
            if case .success(let tasks) = result { XCTAssertEqual(tasks.count, 1); XCTAssertEqual(tasks[0].id, "2") }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)

        XCTAssertEqual(mockAPI.fetchTodosCallCount, 0)
        XCTAssertEqual(mockRepository.fetchAllCallCount, 1)
    }

    func test_searchTasks_callsRepositorySearch() {
        mockRepository.searchResult = .success([])
        let exp = expectation(description: "search")
        sut.searchTasks(query: "query") { _ in exp.fulfill() }
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(mockRepository.searchCallCount, 1)
        XCTAssertEqual(mockRepository.searchLastQuery, "query")
    }

    func test_updateTask_callsRepositoryUpdate() {
        let task = TodoItem(id: "1", title: "T", taskDescription: "", createdAt: Date(), isCompleted: true)
        mockRepository.updateResult = .success(())
        let exp = expectation(description: "update")
        sut.updateTask(task) { _ in exp.fulfill() }
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(mockRepository.updateCallCount, 1)
        XCTAssertEqual(mockRepository.updateLastTask?.id, "1")
    }

    func test_deleteTask_callsRepositoryDelete() {
        mockRepository.deleteResult = .success(())
        let exp = expectation(description: "delete")
        sut.deleteTask(id: "id1") { _ in exp.fulfill() }
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(mockRepository.deleteCallCount, 1)
        XCTAssertEqual(mockRepository.deleteLastId, "id1")
    }
}
