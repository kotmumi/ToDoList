//
//  MockListViewType.swift
//  ToDoListTests
//

import Foundation
@testable import ToDoList

final class MockListViewType: ListViewType {

    var showErrorCallCount = 0
    var showErrorLastMessage: String?

    var setSearchQueryCallCount = 0
    var setSearchQueryLastValue: String?

    var showShareSheetCallCount = 0
    var showShareSheetLastTask: TodoItem?

    func showError(message: String) {
        showErrorCallCount += 1
        showErrorLastMessage = message
    }

    func setSearchQuery(_ query: String) {
        setSearchQueryCallCount += 1
        setSearchQueryLastValue = query
    }

    func showShareSheet(for task: TodoItem) {
        showShareSheetCallCount += 1
        showShareSheetLastTask = task
    }
}
