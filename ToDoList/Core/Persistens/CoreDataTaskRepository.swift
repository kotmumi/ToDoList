//
//  CoreDataTaskRepository.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 1.03.26.
//

import Foundation
import CoreData

final class CoreDataTaskRepository: TaskRepository {

    private let container: NSPersistentContainer
    private let queue = DispatchQueue(label: "com.todolist.taskrepository", qos: .userInitiated)

    init(container: NSPersistentContainer) {
        self.container = container
    }

    func fetchAll(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        let container = self.container
        queue.async {
            let context = container.newBackgroundContext()
            context.perform {
                do {
                    let request = TodoTask.fetchRequest()
                    request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
                    let objects = try context.fetch(request)
                    let items = objects.compactMap { Self.mapToItem($0) }
                    DispatchQueue.main.async { completion(.success(items)) }
                } catch {
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }
        }
    }

    func add(_ task: TodoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        let container = self.container
        queue.async {
            let context = container.newBackgroundContext()
            context.perform {
                do {
                    let obj = TodoTask(context: context)
                    Self.mapFromItem(task, to: obj)
                    try context.save()
                    DispatchQueue.main.async { completion(.success(())) }
                } catch {
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }
        }
    }

    func addAll(_ tasks: [TodoItem], completion: @escaping (Result<Void, Error>) -> Void) {
        let container = self.container
        queue.async {
            let context = container.newBackgroundContext()
            context.perform {
                do {
                    for item in tasks {
                        let obj = TodoTask(context: context)
                        Self.mapFromItem(item, to: obj)
                    }
                    try context.save()
                    DispatchQueue.main.async { completion(.success(())) }
                } catch {
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }
        }
    }

    func update(_ task: TodoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        let container = self.container
        let taskId = task.id
        queue.async {
            let context = container.newBackgroundContext()
            context.perform {
                do {
                    let request = TodoTask.fetchRequest()
                    request.predicate = NSPredicate(format: "%K == %@", "id", taskId)
                    request.fetchLimit = 1
                    guard let obj = try context.fetch(request).first else {
                        DispatchQueue.main.async { completion(.failure(CoreDataTaskRepositoryError.taskNotFound)) }
                        return
                    }
                    Self.mapFromItem(task, to: obj)
                    try context.save()
                    DispatchQueue.main.async { completion(.success(())) }
                } catch {
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }
        }
    }

    func delete(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let container = self.container
        queue.async {
            let context = container.newBackgroundContext()
            context.perform {
                do {
                    let request = TodoTask.fetchRequest()
                    request.predicate = NSPredicate(format: "%K == %@", "id", id)
                    request.fetchLimit = 1
                    guard let obj = try context.fetch(request).first else {
                        DispatchQueue.main.async { completion(.failure(CoreDataTaskRepositoryError.taskNotFound)) }
                        return
                    }
                    context.delete(obj)
                    try context.save()
                    DispatchQueue.main.async { completion(.success(())) }
                } catch {
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }
        }
    }

    func search(query: String, completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        let container = self.container
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        queue.async {
            let context = container.newBackgroundContext()
            context.perform {
                do {
                    let request = TodoTask.fetchRequest()
                    if trimmed.isEmpty {
                        request.predicate = nil
                    } else {
                        request.predicate = NSPredicate(
                            format: "%K CONTAINS[cd] %@ OR %K CONTAINS[cd] %@",
                            "title", trimmed,
                            "taskDescription", trimmed
                        )
                    }
                    request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
                    let objects = try context.fetch(request)
                    let items = objects.compactMap { Self.mapToItem($0) }
                    DispatchQueue.main.async { completion(.success(items)) }
                } catch {
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }
        }
    }

    private static func mapToItem(_ obj: TodoTask) -> TodoItem? {
        guard let id = obj.id,
              let title = obj.title,
              let createdAt = obj.createdAt else {
            return nil
        }
        let taskDescription = obj.taskDescription ?? ""
        return TodoItem(
            id: id,
            title: title,
            taskDescription: taskDescription,
            createdAt: createdAt,
            isCompleted: obj.isCompleted
        )
    }

    private static func mapFromItem(_ item: TodoItem, to obj: TodoTask) {
        obj.id = item.id
        obj.title = item.title
        obj.taskDescription = item.taskDescription
        obj.createdAt = item.createdAt
        obj.isCompleted = item.isCompleted
    }
}

enum CoreDataTaskRepositoryError: Error {
    case taskNotFound
}
