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

    private func saveFetchedTasks(_ items: [TodoItem], completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        let group = DispatchGroup()
        var saveError: Error?
        for item in items {
            group.enter()
            repository.add(item) { result in
                if case .failure(let error) = result { saveError = error }
                group.leave()
            }
        }
        group.notify(queue: .main) { [weak self] in
            if let error = saveError {
                completion(.failure(error))
                return
            }
            FirstLaunch.hasLoadedFromAPI = true
            self?.repository.fetchAll(completion: completion)
        }
    }
}
