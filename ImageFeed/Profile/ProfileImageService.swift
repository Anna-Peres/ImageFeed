//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 23.04.2025.
//

import UIKit

enum ProfileImageServiceError: Error {
    case invalidRequest
}

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private init() {}
    private(set) var avatarURL: String?
    private let session = URLSession.shared
    private var task: URLSessionTask?
    private let storage = OAuth2TokenStorage()
    
    func fetchProfileImageURL(username: String, _ handler: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        let url = URL(string: "https://api.unsplash.com//users/\(username)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        guard let token = storage.token else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .success(let decodedResponse):
                guard let profileImage = decodedResponse.profileImage else { return }
                guard let smallProfileImage = profileImage["small"] else { return }
                self?.avatarURL = smallProfileImage
                handler(.success(smallProfileImage))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": smallProfileImage])
            case .failure(let error):
                print("[ProfileImageService]: \(error.localizedDescription)")
                handler(.failure(error))
            }
            self?.task = nil
        }
        task.resume()
    }
}

struct UserResult: Codable {
    let profileImage: [String: String]?
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
    
    static func decode(from data: Data) -> Result<String, Error> {
        let decoder = JSONDecoder()
        do {
            let decodedResponse = try decoder.decode(UserResult.self, from: data)
            
            guard let profileImage = decodedResponse.profileImage else { return .failure(ProfileImageServiceError.invalidRequest) }
            guard let smallProfileImage = profileImage["small"] else { return .failure(ProfileImageServiceError.invalidRequest)}
            
            return .success(smallProfileImage)
        } catch {
            print("Error in data decoding")
            return .failure(error)
        }
    }
}
