//
//  AddEditContract.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 1.03.26.
//

import Foundation

protocol AddEditViewType: AnyObject {
    func setTitle(_ text: String)
    func setDescription(_ text: String)
    func setDate(_ text: String)
    func showError(message: String)
}

protocol AddEditPresenting: AnyObject {
    var isEditMode: Bool { get }
    func viewDidLoad()
    func didTapBack(title: String, description: String)
}

protocol AddEditDataProviding: AnyObject {
    func addTask(_ task: TodoItem, completion: @escaping (Result<Void, Error>) -> Void)
    func updateTask(_ task: TodoItem, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol AddEditRouting: AnyObject {
    func pop()
}
