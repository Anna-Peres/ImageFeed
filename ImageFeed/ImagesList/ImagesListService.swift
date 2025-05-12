//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 30.04.2025.
//
import Foundation

enum ImagesListServiceError: Error {
    case somethingWentWrong
}

final class ImagesListService {
    private let session = URLSession.shared
    private var task: URLSessionTask?
    private let storage = OAuth2TokenStorage()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListService.didChangeNotification")
    var imageListServiceObserver: NSObjectProtocol?
    static let shared = ImagesListService()
    private var pageNumber = 1
    private let decoder = JSONDecoder()
    var photos: [Photo] = []
    
    private init() {}
    
    func fetchPhotosNextPage(completion: @escaping (Error?) -> Void) {
        guard task == nil,
              let request = request()
        else { return }
        
        
        let completionOnMainQueue: (Error?) -> Void = { error in
            DispatchQueue.main.async {
                completion(error)
            }
        }
        
        task = session.dataTask(with: request) { [weak self] data, response, error in
            
            guard let self else { return }
            
            if let error {
                completionOnMainQueue(error)
                print("[ImageListService]: error task")
            }
            
            if let data {
                do {
                    let responseImages = try decoder.decode([PhotoResult].self, from: data)

                    DispatchQueue.main.async {
                        self.photos.append(
                            contentsOf: responseImages.map {
                                .init(
                                    id: $0.id,
                                    size: CGSize(width: $0.width, height: $0.height),
                                    createdAt: ISO8601DateFormatter().date(from: $0.createdAt ?? ""),
                                    welcomeDescription: $0.description,
                                    thumbImageURL: $0.urls.thumb,
                                    fullImageURL: $0.urls.full,
                                    isLiked: $0.likedByUser)
                            }
                        )
                        self.pageNumber += 1
                        completionOnMainQueue(nil)
                        NotificationCenter.default
                            .post(
                                name: ImagesListService.didChangeNotification,
                                object: self,
                                userInfo: nil)
                    }
                } catch {
                    completionOnMainQueue(error)
                    print("[ImageListService]: error decoding")
                }
            } else {
                completion(ImagesListServiceError.somethingWentWrong)
                print("[ImageListService]: something went wrong")
            }
            
            task = nil
        }
        task?.resume()
    }
    
    private func request() -> URLRequest? {
        var components = URLComponents(string: "https://api.unsplash.com/photos")
        components?.queryItems = [URLQueryItem(name: "page", value: String(pageNumber))]
        guard
            let url = components?.url,
            let token = storage.token
        else { return nil }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        var components = URLComponents(string: "https://api.unsplash.com/photos/\(photoId)/like")
        components?.queryItems = [URLQueryItem(name: "id", value: photoId)]
        guard
            let url = components?.url,
            let token = storage.token
        else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        if isLike {
            request.httpMethod = "DELETE"
        } else {
            request.httpMethod = "POST"
        }
        
        task?.cancel()
        
        task = session.dataTaskWithResult(for: request) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(
                            id: photo.id,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welcomeDescription: photo.welcomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            fullImageURL: photo.fullImageURL,
                            isLiked: !photo.isLiked
                        )
                        self.photos[index] = newPhoto
                    }
                    completion(.success(()))
                }
            case .failure(let error):
                print("[ImagesListService]: error while changing like")
                completion(.failure(error))
            }
            
            task = nil
        }
        task?.resume()
    }
    
    func cleanPhotos() {
        photos.removeAll()
    }
}

