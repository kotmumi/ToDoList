//
//  ListPresenterTests.swift
//  ToDoListTests
//

import Combine
import XCTest
@testable import ToDoList

final class ListPresenterTests: XCTestCase {

    var mockInteractor: MockListDataProviding!
    var mockRouter: MockListRouting!
    var mockView: MockListViewType!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockInteractor = MockListDataProviding()
        mockRouter = MockListRouting()
        mockView = MockListViewType()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        mockView = nil
        mockRouter = nil
        mockInteractor = nil
        super.tearDown()
    }

    func test_viewDidLoad_success_updatesTasks() {
        let tasks = [TodoItem(id: "1", title: "T", taskDescription: "", createdAt: Date(), isCompleted: false)]
        mockInteractor.fetchTasksResult = .success(tasks)
        let sut = ListPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)

        let exp = expectation(description: "tasks")
        sut.tasksPublisher.sink { value in
            if value.count == 1 { exp.fulfill() }
        }.store(in: &cancellables)

        sut.viewDidLoad()
        DispatchQueue.main.async { }
        wait(for: [exp], timeout: 2)
        XCTAssertEqual(sut.numberOfTasks, 1)
        XCTAssertEqual(sut.task(at: 0)?.title, "T")
    }

    func test_viewDidLoad_failure_sendsError() {
        mockInteractor.fetchTasksResult = .failure(NSError(domain: "t", code: -1, userInfo: [NSLocalizedDescriptionKey: "Fail"]))
        let sut = ListPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)

        let exp = expectation(description: "error")
        sut.errorPublisher.sink { msg in
            XCTAssertEqual(msg, "Fail")
            exp.fulfill()
        }.store(in: &cancellables)

        sut.viewDidLoad()
        wait(for: [exp], timeout: 2)
    }

    func test_didChangeSearchQuery_empty_fetchesTasks() {
        mockInteractor.fetchTasksResult = .success([])
        let sut = ListPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
        let exp = expectation(description: "fetch")
        sut.tasksPublisher.dropFirst().sink { _ in exp.fulfill() }.store(in: &cancellables)

        sut.didChangeSearchQuery("")
        wait(for: [exp], timeout: 2)
        XCTAssertEqual(mockInteractor.fetchTasksCallCount, 1)
    }

    func test_didChangeSearchQuery_nonEmpty_callsSearchTasks() {
        mockInteractor.searchTasksResult = .success([])
        let sut = ListPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
        let exp = expectation(description: "search")
        sut.tasksPublisher.dropFirst().sink { _ in exp.fulfill() }.store(in: &cancellables)

        sut.didChangeSearchQuery("  query  ")
        wait(for: [exp], timeout: 2)
        XCTAssertEqual(mockInteractor.searchTasksCallCount, 1)
        XCTAssertEqual(mockInteractor.searchTasksQuery, "query")
    }

    func test_didTapAdd_opensAddTask() {
        let sut = ListPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
        sut.didTapAdd()
        XCTAssertEqual(mockRouter.openAddTaskCallCount, 1)
    }

    func test_didSelectTask_opensTaskDetail() {
        let task = TodoItem(id: "1", title: "T", taskDescription: "", createdAt: Date(), isCompleted: false)
        let sut = ListPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
        sut.didSelectTask(task)
        XCTAssertEqual(mockRouter.openTaskDetailCallCount, 1)
        XCTAssertEqual(mockRouter.openTaskDetailLastTask?.id, "1")
    }

    func test_didTapComplete_success_updatesTasks() {
        let task = TodoItem(id: "1", title: "T", taskDescription: "", createdAt: Date(), isCompleted: false)
        mockInteractor.fetchTasksResult = .success([task])
        mockInteractor.updateTaskResult = .success(())
        let sut = ListPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
        let loadExp = expectation(description: "load")
        sut.tasksPublisher
            .dropFirst()
            .prefix(1)
            .sink { _ in loadExp.fulfill() }
            .store(in: &cancellables)
        sut.viewDidLoad()
        wait(for: [loadExp], timeout: 2)

        let updateExp = expectation(description: "update")
        sut.tasksPublisher.dropFirst().sink { tasks in
            if tasks.first?.isCompleted == true { updateExp.fulfill() }
        }.store(in: &cancellables)
        sut.didTapComplete(task)
        wait(for: [updateExp], timeout: 2)
        XCTAssertEqual(mockInteractor.updateTaskCallCount, 1)
    }

    func test_didTapComplete_failure_sendsError() {
        let task = TodoItem(id: "1", title: "T", taskDescription: "", createdAt: Date(), isCompleted: false)
        mockInteractor.fetchTasksResult = .success([task])
        mockInteractor.updateTaskResult = .failure(NSError(domain: "t", code: -1, userInfo: [NSLocalizedDescriptionKey: "Update error"]))
        let sut = ListPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
        let loadExp = expectation(description: "load")
        sut.tasksPublisher
            .dropFirst()
            .prefix(1)
            .sink { _ in loadExp.fulfill() }
            .store(in: &cancellables)
        sut.viewDidLoad()
        wait(for: [loadExp], timeout: 2)

        let errExp = expectation(description: "error")
        sut.errorPublisher.sink { msg in
            XCTAssertEqual(msg, "Update error")
            errExp.fulfill()
        }.store(in: &cancellables)
        sut.didTapComplete(task)
        wait(for: [errExp], timeout: 2)
    }

    func test_didRequestDelete_success_removesTask() {
        let task = TodoItem(id: "1", title: "T", taskDescription: "", createdAt: Date(), isCompleted: false)
        mockInteractor.fetchTasksResult = .success([task])
        mockInteractor.deleteTaskResult = .success(())
        let sut = ListPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
        let loadExp = expectation(description: "load")
        sut.tasksPublisher
            .dropFirst()
            .prefix(1)
            .sink { _ in loadExp.fulfill() }
            .store(in: &cancellables)
        sut.viewDidLoad()
        wait(for: [loadExp], timeout: 2)

        let deleteExp = expectation(description: "delete")
        sut.tasksPublisher.dropFirst().sink { tasks in
            if tasks.isEmpty { deleteExp.fulfill() }
        }.store(in: &cancellables)
        sut.didRequestDelete(task)
        wait(for: [deleteExp], timeout: 2)
        XCTAssertEqual(mockInteractor.deleteTaskCallCount, 1)
    }

    func test_didRequestDelete_failure_sendsError() {
        let task = TodoItem(id: "1", title: "T", taskDescription: "", createdAt: Date(), isCompleted: false)
        mockInteractor.fetchTasksResult = .success([task])
        mockInteractor.deleteTaskResult = .failure(NSError(domain: "t", code: -1, userInfo: [NSLocalizedDescriptionKey: "Delete error"]))
        let sut = ListPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
        let loadExp = expectation(description: "load")
        sut.tasksPublisher
            .dropFirst()
            .prefix(1)
            .sink { _ in loadExp.fulfill() }
            .store(in: &cancellables)
        sut.viewDidLoad()
        wait(for: [loadExp], timeout: 2)

        let errExp = expectation(description: "error")
        sut.errorPublisher.sink { msg in
            XCTAssertEqual(msg, "Delete error")
            errExp.fulfill()
        }.store(in: &cancellables)
        sut.didRequestDelete(task)
        wait(for: [errExp], timeout: 2)
    }

    func test_didRequestShare_showsShareSheet() {
        let task = TodoItem(id: "1", title: "T", taskDescription: "", createdAt: Date(), isCompleted: false)
        let sut = ListPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
        sut.didRequestShare(task)
        XCTAssertEqual(mockView.showShareSheetCallCount, 1)
        XCTAssertEqual(mockView.showShareSheetLastTask?.id, "1")
    }
}
