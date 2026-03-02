//
//  AddEditRouter.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 1.03.26.
//

import UIKit

final class AddEditRouter: AddEditRouting {

    weak var viewController: UIViewController?

    func dismiss() {
        viewController?.dismiss(animated: true)
    }

    func dismissAfterSave() {
        viewController?.dismiss(animated: true)
    }
}
