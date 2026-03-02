//
//  AddEditViewController.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 1.03.26.
//

import UIKit

final class AddEditViewController: UIViewController {

    private let presenter: AddEditPresenting
    private let addEditView = AddEditView()

    init(presenter: AddEditPresenting) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view = addEditView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        presenter.viewDidLoad()
    }
}

extension AddEditViewController {

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: L10n.cancel,
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: L10n.save,
            style: .done,
            target: self,
            action: #selector(saveTapped)
        )
    }

    @objc private func saveTapped() {
        presenter.didTapSave(title: addEditView.titleText, description: addEditView.descriptionText)
    }

    @objc private func cancelTapped() {
        presenter.didTapCancel()
    }
}

extension AddEditViewController: AddEditViewType {

    func setTitle(_ text: String) {
        addEditView.setTitle(text)
    }

    func setDescription(_ text: String) {
        addEditView.setDescription(text)
    }

    func setDate(_ text: String) {
        addEditView.setDate(text)
    }

    func showError(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
