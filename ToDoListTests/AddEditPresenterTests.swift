//
//  AddEditPresenterTests.swift
//  ToDoListTests
//

import XCTest
@testable import ToDoList

final class AddEditPresenterTests: XCTestCase {

    var mockInteractor: MockAddEditDataProviding!
    var mockRouter: MockAddEditRouting!
    var mockView: MockAddEditViewType!

    override func setUp() {
        super.setUp()
        mockInteractor = MockAddEditDataProviding()
        mockRouter = MockAddEditRouting()
        mockView = MockAddEditViewType()
    }

    override func tearDown() {
        mockView = nil
        mockRouter = nil
        mockInteractor = nil
        super.tearDown()
    }

    func test_isEditMode_trueWhenTaskProvided() {
        let task = TodoItem(id: "1", title: "A", taskDescription: "B", createdAt: Date(), isCompleted: false)
        let sut = AddEditPresenter(interactor: mockInteractor, router: mockRouter, task: task)
        XCTAssertTrue(sut.isEditMode)
    }

    func test_isEditMode_falseWhenTaskNil() {
        let sut = AddEditPresenter(interactor: mockInteractor, router: mockRouter, task: nil)
        XCTAssertFalse(sut.isEditMode)
    }

    func test_viewDidLoad_addMode_setsEmptyFields() {
        let sut = AddEditPresenter(interactor: mockInteractor, router: mockRouter, task: nil)
        sut.view = mockView
        sut.viewDidLoad()
        XCTAssertEqual(mockView.setTitleLastValue, "")
        XCTAssertEqual(mockView.setDescriptionLastValue, "")
    }

    func test_viewDidLoad_editMode_setsTaskFields() {
        let task = TodoItem(id: "1", title: "Title", taskDescription: "Desc", createdAt: Date(), isCompleted: false)
        let sut = AddEditPresenter(interactor: mockInteractor, router: mockRouter, task: task)
        sut.view = mockView
        sut.viewDidLoad()
        XCTAssertEqual(mockView.setTitleLastValue, "Title")
        XCTAssertEqual(mockView.setDescriptionLastValue, "Desc")
    }

    func test_didTapBack_emptyTitle_showsError() {
        let sut = AddEditPresenter(interactor: mockInteractor, router: mockRouter, task: nil)
        sut.view = mockView
        sut.didTapBack(title: "   ", description: "any")
        XCTAssertEqual(mockView.showErrorCallCount, 1)
        XCTAssertEqual(mockInteractor.addTaskCallCount, 0)
    }

    func test_didTapBack_addSuccess_pops() {
        let sut = AddEditPresenter(interactor: mockInteractor, router: mockRouter, task: nil)
        sut.view = mockView
        mockInteractor.addTaskResult = .success(())
        let exp = expectation(description: "async")
        sut.didTapBack(title: "New", description: "Desc")
        DispatchQueue.main.async { exp.fulfill() }
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(mockInteractor.addTaskCallCount, 1)
        XCTAssertEqual(mockRouter.popCallCount, 1)
    }

    func test_didTapBack_addFailure_showsError() {
        let sut = AddEditPresenter(interactor: mockInteractor, router: mockRouter, task: nil)
        sut.view = mockView
        mockInteractor.addTaskResult = .failure(NSError(domain: "test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Add failed"]))
        let exp = expectation(description: "async")
        sut.didTapBack(title: "New", description: "")
        DispatchQueue.main.async { exp.fulfill() }
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(mockView.showErrorCallCount, 1)
        XCTAssertEqual(mockView.showErrorLastMessage, "Add failed")
        XCTAssertEqual(mockRouter.popCallCount, 0)
    }

    func test_didTapBack_editSuccess_pops() {
        let task = TodoItem(id: "1", title: "Old", taskDescription: "D", createdAt: Date(), isCompleted: false)
        let sut = AddEditPresenter(interactor: mockInteractor, router: mockRouter, task: task)
        sut.view = mockView
        mockInteractor.updateTaskResult = .success(())
        let exp = expectation(description: "async")
        sut.didTapBack(title: "Updated", description: "NewDesc")
        DispatchQueue.main.async { exp.fulfill() }
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(mockInteractor.updateTaskCallCount, 1)
        XCTAssertEqual(mockRouter.popCallCount, 1)
    }

    func test_didTapBack_editFailure_showsError() {
        let task = TodoItem(id: "1", title: "Old", taskDescription: "D", createdAt: Date(), isCompleted: false)
        let sut = AddEditPresenter(interactor: mockInteractor, router: mockRouter, task: task)
        sut.view = mockView
        mockInteractor.updateTaskResult = .failure(NSError(domain: "test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Update failed"]))
        let exp = expectation(description: "async")
        sut.didTapBack(title: "Updated", description: "")
        DispatchQueue.main.async { exp.fulfill() }
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(mockView.showErrorCallCount, 1)
        XCTAssertEqual(mockRouter.popCallCount, 0)
    }
}
