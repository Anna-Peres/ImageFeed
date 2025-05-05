//
//  ImagesListServic.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 30.04.2025.
//
import Foundation

enum ImageListServiceError: Error {
    case somethingWentWrong
}

final class ImagesListService {
    private var lastLoadedPage: Int?
    private let session = URLSession.shared
    private var task: URLSessionTask?
    private let storage = OAuth2TokenStorage()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListService.didChangeNotification")
    
    private var pageNumber = 1
    private let decoder = JSONDecoder()
    var images: [Image] = []
    
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
            }
            
            if let data {
                do {
                    let responseImages = try decoder.decode([ResponseImage].self, from: data)
                    
                    images.append(
                        contentsOf: responseImages.map {
                            .init(
                                id: $0.id,
                                size: CGSize(width: $0.width, height: $0.height),
                                createdAt: $0.createdAt,
                                welcomeDescription: $0.description,
                                thumbImageURL: $0.urls.thumb,
                                largeImageURL: $0.urls.regular,
                                isLiked: $0.likedByUser)
                        }
                    )
                    pageNumber += 1
                    completionOnMainQueue(nil)
                    NotificationCenter.default
                        .post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["page": pageNumber, "per_page": 10])
                } catch {
                    completionOnMainQueue(error)
                }
            } else {
                completion(ImageListServiceError.somethingWentWrong)
            }
            
            task = nil
        }
        task?.resume()
    }
    
    struct ResponseImage: Decodable {
        let id: String
        let width: Int
        let height: Int
        let createdAt: String?
        let description: String?
        let urls: ResponseImageUrls
        let likedByUser: Bool
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case width = "width"
            case height = "height"
            case createdAt = "created_at"
            case description = "description"
            case urls = "urls"
            case likedByUser = "liked_by_user"
        }
    }
    
    struct ResponseImageUrls: Decodable {
        let thumb: String
        let regular: String
    }
    
    struct Image {
        let id: String
        let size: CGSize
        let createdAt: String?
        let welcomeDescription: String?
        let thumbImageURL: String
        let largeImageURL: String
        let isLiked: Bool
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
            request.httpMethod = "POST"
        } else {
            request.httpMethod = "DELETE"
        }
        
        guard task == nil else { return }
        
        
        let completionOnMainQueue: (Error?) -> Void = { error in
            DispatchQueue.main.async {
                print("[ImagesListService] - error")
            }
        }
        
        task = session.dataTask(with: request) { [weak self] data, response, error in
            
            guard let self else { return }
            
            if let error {
                completionOnMainQueue(error)
            }
            
            if let data {
                if let index = self.images.firstIndex(where: { $0.id == photoId }) {
                    // Текущий элемент
                    let photo = self.images[index]
                    // Копия элемента с инвертированным значением isLiked.
                    let newPhoto = Image(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked
                    )
                    // Заменяем элемент в массиве.
                    self.images[index] = newPhoto
                    completionOnMainQueue(nil)
                }
                completionOnMainQueue(error)
            } else {
                print("[ImageListService]: something went wrong")
            }
            
            task = nil
        }
        task?.resume()
    }
}

