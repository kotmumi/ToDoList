//
//  AddEditView.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 1.03.26.
//

import UIKit

final class AddEditView: UIView {

    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: FontSize.largeTitle, weight: .bold)
        textField.textColor = AppColor.textPrimary
        return textField
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: FontSize.caption, weight: .bold)
        label.textColor = AppColor.textSecondary
        return label
    }()

    private let descriptionPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: FontSize.caption, weight: .regular)
        label.textColor = AppColor.textSecondary
        label.isUserInteractionEnabled = false
        return label
    }()

    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: FontSize.caption, weight: .regular)
        textView.textColor = AppColor.textPrimary
        textView.backgroundColor = .clear
        return textView
    }()

    var titleText: String { titleTextField.text ?? "" }
    var descriptionText: String { descriptionTextView.text ?? "" }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupDescriptionPlaceholder()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddEditView {

    private func setupUI() {
        backgroundColor = AppColor.backgroundPrimary
        titleTextField.placeholder = L10n.titlePlaceholder
        descriptionPlaceholderLabel.text = L10n.descriptionPlaceholder
        addSubview(titleTextField)
        addSubview(dateLabel)
        addSubview(descriptionTextView)
        addSubview(descriptionPlaceholderLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Spacing.small),
            titleTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.medium),
            titleTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.medium),

            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: Spacing.medium),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.medium),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.medium),

            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Spacing.medium),
            descriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.medium),
            descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.medium),
            descriptionTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Spacing.small),

            descriptionPlaceholderLabel.topAnchor.constraint(equalTo: descriptionTextView.topAnchor, constant: 8),
            descriptionPlaceholderLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor, constant: 5),
        ])
    }

    private func setupDescriptionPlaceholder() {
        descriptionTextView.delegate = self
    }
}

extension AddEditView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        descriptionPlaceholderLabel.isHidden = !(textView.text ?? "").isEmpty
    }
}

extension AddEditView: AddEditViewType {

    func setTitle(_ text: String) {
        titleTextField.text = text
    }

    func setDescription(_ text: String) {
        descriptionTextView.text = text
        descriptionPlaceholderLabel.isHidden = !text.isEmpty
    }

    func setDate(_ text: String) {
        dateLabel.text = text
    }

    func showError(message: String) {
        // View only displays; ViewController will show alert
    }
}
