//
//  DummyJSONService.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 1.03.26.
//

import Foundation

enum DummyJSONServiceError: Error {
    case invalidURL
    case noData
    case decodingFailed(Error)
    case networkError(Error)
}

protocol TodosFetching: AnyObject {
    func fetchTodos(completion: @escaping (Result<[TodoItem], Error>) -> Void)
}

final class DummyJSONService: TodosFetching {
    
    private let urlString = "https://dummyjson.com/todos"
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    func fetchTodos(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async { completion(.failure(DummyJSONServiceError.invalidURL)) }
            return
        }
        
        let task = session.dataTask(with: url) { [decoder] data, _, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(DummyJSONServiceError.networkError(error))) }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(DummyJSONServiceError.noData)) }
                return
            }
            do {
                let response = try decoder.decode(TodosResponse.self, from: data)
                let items = response.todos.map { $0.toDomain() }
                DispatchQueue.main.async { completion(.success(items)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(DummyJSONServiceError.decodingFailed(error))) }
            }
        }
        task.resume()
    }
}
