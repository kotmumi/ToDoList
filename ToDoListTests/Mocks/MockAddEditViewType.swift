//
//  MockAddEditViewType.swift
//  ToDoListTests
//

import Foundation
@testable import ToDoList

final class MockAddEditViewType: AddEditViewType {

    var setTitleCallCount = 0
    var setTitleLastValue: String?

    var setDescriptionCallCount = 0
    var setDescriptionLastValue: String?

    var setDateCallCount = 0
    var setDateLastValue: String?

    var showErrorCallCount = 0
    var showErrorLastMessage: String?

    func setTitle(_ text: String) {
        setTitleCallCount += 1
        setTitleLastValue = text
    }

    func setDescription(_ text: String) {
        setDescriptionCallCount += 1
        setDescriptionLastValue = text
    }

    func setDate(_ text: String) {
        setDateCallCount += 1
        setDateLastValue = text
    }

    func showError(message: String) {
        showErrorCallCount += 1
        showErrorLastMessage = message
    }
}
