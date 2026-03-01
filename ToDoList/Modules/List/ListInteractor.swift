//
//  ListInteractor.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 28.02.26.
//

import Foundation

private enum FirstLaunch {
    static let hasLoadedFromAPIKey = "hasLoadedTodosFromAPI"
    static var hasLoadedFromAPI: Bool {
        get { UserDefaults.standard.bool(forKey: hasLoadedFromAPIKey) }
        set { UserDefaults.standard.set(newValue, forKey: hasLoadedFromAPIKey) }
    }
}

final class ListInteractor: ListDataProviding {

    private let repository: TaskRepository
    private let apiService: TodosFetching

    init(repository: TaskRepository, apiService: TodosFetching) {
        self.repository = repository
        self.apiService = apiService
    }

    func fetchTasks(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        if FirstLaunch.hasLoadedFromAPI {
            repository.fetchAll(completion: completion)
            return
        }
        apiService.fetchTodos { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let items):
                self.saveFetchedTasks(items, completion: completion)
            case .failure(let error):
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }

    func searchTasks(query: String, completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        repository.search(query: query, completion: completion)
    }

    func updateTask(_ task: TodoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.update(task, completion: completion)
    }

    private func saveFetchedTasks(_ items: [TodoItem], completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        repository.addAll(items) { [weak self] result in
            switch result {
            case .success:
                FirstLaunch.hasLoadedFromAPI = true
                self?.repository.fetchAll(completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
