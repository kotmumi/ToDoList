
//  ListView.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 28.02.26.
//

import UIKit

final class ListView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = L10n.title
        label.font = .systemFont(ofSize: FontSize.largeTitle, weight: .bold)
        label.textColor = AppColor.textPirimary
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ListView {
    private func setupUI() {
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
        ])
    }
}
