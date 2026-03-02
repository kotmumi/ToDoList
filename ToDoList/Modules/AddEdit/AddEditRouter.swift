//
//  AddEditRouter.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 1.03.26.
//

import UIKit

final class AddEditRouter: AddEditRouting {

    weak var viewController: UIViewController?

    func pop() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
