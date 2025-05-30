//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 27.03.2025.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    private static let decoder = JSONDecoder()
    
    func dataTaskWithResult(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        return task
    }
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = dataTaskWithResult(for: request) { (result: Result<Data, Error>) in
            // TODO [Sprint 11] Напишите реализацию c декодированием Data в тип T
            switch result {
            case .success(let data):
//                print(String(data: data, encoding: .utf8) ?? "Data not found")
                do {
                    let decodedResponse = try Self.decoder.decode(T.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    print("Error decoding: \(error.localizedDescription), data: \(String(data: data, encoding: .utf8) ?? "")")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Error request: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        return task
    }
}

