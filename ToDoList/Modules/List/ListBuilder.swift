//
//  ListBuilder.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 28.02.26.
//

import UIKit

final class ListBuilder {
    func build() -> UIViewController {
        
       // let interactor = ListInteractor(repository: repository)
        let router = ListRouter()
        let presenter = ListPresenter(interactor: interactor, router: router)
        let viewController = ListViewController(presenter: presenter)
       // viewController.presenter = presenter
        router.viewController = viewController
        presenter.view = viewController
        
        return viewController
    }
}
