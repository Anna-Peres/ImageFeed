//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 13.05.2025.
//

import Foundation

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    func viewDidLoad()
    func loadImages()
    func didTapLike(at indexPath: IndexPath, completion: @escaping (Bool) -> Void)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    var photos: [Photo] {
        imagesListService.photos
    }
    
    weak var view: ImagesListViewControllerProtocol?
    private let imagesListService = ImagesListService.shared
    
    func viewDidLoad() {
        print("Presenter loaded")
        updateImagesList()
        loadImages()
    }
    
    func didTapLike(at indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
        let photo = imagesListService.photos[indexPath.row]
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(true)
                case .failure:
                    completion(false)
                }
            }
        }
    }
    
    func updateImagesList() {
        imagesListService.imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard (self?.view) != nil else { return }
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    print("Updating tableView after photos loaded")
                    self.view?.updateTableViewAnimated()
                }
            }
    }
    
    func loadImages() {
        imagesListService.fetchPhotosNextPage { [weak self] error in
            guard let self else { return }
            
            if let error {
                print(error.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    self.view?.updateTableViewAnimated()
                }
            }
        }
    }
}


