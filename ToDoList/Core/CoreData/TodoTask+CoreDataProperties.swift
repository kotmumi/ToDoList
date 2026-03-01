//
//  TodoTask+CoreDataProperties.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 1.03.26.
//
//

public import Foundation
public import CoreData


public typealias TodoTaskCoreDataPropertiesSet = NSSet

extension TodoTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoTask> {
        return NSFetchRequest<TodoTask>(entityName: "TodoTask")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var isCompleted: Bool

}

extension TodoTask : Identifiable {

}
