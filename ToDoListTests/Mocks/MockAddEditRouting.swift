//
//  MockAddEditRouting.swift
//  ToDoListTests
//

import Foundation
@testable import ToDoList

final class MockAddEditRouting: AddEditRouting {

    var popCallCount = 0

    func pop() {
        popCallCount += 1
    }
}
