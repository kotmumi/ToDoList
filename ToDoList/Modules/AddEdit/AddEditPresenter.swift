//
//  AddEditPresenter.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 1.03.26.
//

import Foundation

final class AddEditPresenter {

    weak var view: AddEditViewType?
    private let interactor: AddEditDataProviding
    private let router: AddEditRouting
    private let task: TodoItem?

    var isEditMode: Bool { task != nil }

    init(interactor: AddEditDataProviding, router: AddEditRouting, task: TodoItem?) {
        self.interactor = interactor
        self.router = router
        self.task = task
    }
    
    private func userMessage(for error: Error) -> String {
        if let localizedError = error as? LocalizedError,
           let description = localizedError.errorDescription {
            return description
        }
        
        let description = error.localizedDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        return description.isEmpty ? L10n.errorUnknown : description
    }
}

extension AddEditPresenter: AddEditPresenting {

    func viewDidLoad() {
        if let task = task {
            view?.setTitle(task.title)
            view?.setDescription(task.taskDescription)
            view?.setDate(task.createdAt.formatted(date: .numeric, time: .omitted))
        } else {
            view?.setTitle("")
            view?.setDescription("")
            view?.setDate(Date().formatted(date: .numeric, time: .omitted))
        }
    }

    func didTapBack(title: String, description: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            view?.showError(message: L10n.titleRequired)
            return
        }
        if let existing = task {
            var updated = existing
            updated.title = trimmedTitle
            updated.taskDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
            interactor.updateTask(updated) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.router.pop()
                    case .failure(let error):
                        self?.view?.showError(message: self?.userMessage(for: error) ?? L10n.errorUnknown)
                    }
                }
            }
        } else {
            let newTask = TodoItem(
                id: UUID().uuidString,
                title: trimmedTitle,
                taskDescription: description.trimmingCharacters(in: .whitespacesAndNewlines),
                createdAt: Date(),
                isCompleted: false
            )
            interactor.addTask(newTask) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.router.pop()
                    case .failure(let error):
                        self?.view?.showError(message: self?.userMessage(for: error) ?? L10n.errorUnknown)
                    }
                }
            }
        }
    }
}
