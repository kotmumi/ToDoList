//
//  ListRouter.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 28.02.26.
//

import UIKit

final class ListRouter: ListRouting {

    weak var viewController: ListViewType?

    var buildAddEdit: ((TodoItem?) -> UIViewController)?

    func openAddTask() {
        guard let from = viewController as? UIViewController,
              let addEditVC = buildAddEdit?(nil) else { return }
        from.navigationController?.pushViewController(addEditVC, animated: true)
    }

    func openTaskDetail(_ task: TodoItem) {
        guard let from = viewController as? UIViewController,
              let addEditVC = buildAddEdit?(task) else { return }
        from.navigationController?.pushViewController(addEditVC, animated: true)
    }
}
