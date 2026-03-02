//
//  AddEditRouter.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 1.03.26.
//

import UIKit

final class AddEditRouter: AddEditRouting {

    weak var viewController: UIViewController?
    var onPopCompletion: (() -> Void)?

    func pop() {
        onPopCompletion?()
        viewController?.navigationController?.popViewController(animated: true)
    }
}
