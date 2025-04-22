//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 16.04.2025.
//

import Foundation

enum ProfileServiceError: Error {
    case invalidRequest
}

final class ProfileService {
    static let shared = ProfileService()
    private init() {}
    private let session = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    func fetchProfile(_ token: String, handler: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        let url = URL(string: "https://api.unsplash.com/me")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = session.profileData(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let decodedResponse):
                let user = Profile(username: decodedResponse.username,
                                   name: "\(decodedResponse.firstName) \(decodedResponse.lastName ?? "")",
                                   loginName: "@\(decodedResponse.username)",
                                   bio: decodedResponse.bio ?? "")
                self?.profile = user
                handler(.success(user))
            case .failure(let error):
                handler(.failure(error))
            }
            self?.task = nil
        }
        task.resume()
    }
}
