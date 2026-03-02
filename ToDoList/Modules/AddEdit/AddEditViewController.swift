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
        navigationItem.hidesBackButton = true
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.left")
        config.title = L10n.back
        config.imagePadding = 4
        config.baseForegroundColor = AppColor.accent
        let backButton = UIButton(configuration: config, primaryAction: UIAction { [weak self] _ in
            self?.backTapped()
        })
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    @objc private func backTapped() {
        presenter.didTapBack(title: addEditView.titleText, description: addEditView.descriptionText)
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
        alert.addAction(UIAlertAction(title: L10n.ok, style: .default))
        present(alert, animated: true)
    }
}
