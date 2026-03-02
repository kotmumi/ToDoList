//
//  MockListRouting.swift
//  ToDoListTests
//

import Foundation
@testable import ToDoList

final class MockListRouting: ListRouting {

    var openAddTaskCallCount = 0
    var openTaskDetailCallCount = 0
    var openTaskDetailLastTask: TodoItem?

    func openAddTask() {
        openAddTaskCallCount += 1
    }

    func openTaskDetail(_ task: TodoItem) {
        openTaskDetailCallCount += 1
        openTaskDetailLastTask = task
    }
}
