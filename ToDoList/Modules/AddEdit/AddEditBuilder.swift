//
//  AddEditBuilder.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 1.03.26.
//

import UIKit
import CoreData

final class AddEditBuilder {

    func build(container: NSPersistentContainer, task: TodoItem?, onDismiss: (() -> Void)? = nil) -> UIViewController {
        let repository = CoreDataTaskRepository(container: container)
        let interactor = AddEditInteractor(repository: repository)
        let router = AddEditRouter()
        let presenter = AddEditPresenter(interactor: interactor, router: router, task: task)
        let viewController = AddEditViewController(presenter: presenter)
        router.viewController = viewController
        router.onPopCompletion = onDismiss
        presenter.view = viewController
        return viewController
    }
}
