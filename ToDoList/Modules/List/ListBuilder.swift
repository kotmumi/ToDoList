//
//  ListBuilder.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 28.02.26.
//

import UIKit
import CoreData

final class ListBuilder {
    func build(container: NSPersistentContainer) -> UIViewController {
        let repository = CoreDataTaskRepository(container: container)
        let apiService = DummyJSONService()
        let interactor = ListInteractor(repository: repository, apiService: apiService)
        let router = ListRouter()
        let presenter = ListPresenter(interactor: interactor, router: router)
        let viewController = ListViewController(presenter: presenter)
        router.viewController = viewController
        presenter.view = viewController
        router.buildAddEdit = { task in
            AddEditBuilder().build(container: container, task: task)
        }
        return viewController
    }
}
