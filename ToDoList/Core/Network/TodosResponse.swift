//
//  TodosResponse.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 1.03.26.
//

import Foundation

struct TodoDTO: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

extension TodoDTO {
    func toDomain() -> TodoItem {
        TodoItem(
            id: String(id),
            title: todo,
            taskDescription: "",           // в API нет
            createdAt: Date(),            // дата при импорте
            isCompleted: completed
        )
    }
}

struct TodosResponse: Codable {
    let todos: [TodoDTO]
    let total: Int
    let skip: Int
    let limit: Int
}
