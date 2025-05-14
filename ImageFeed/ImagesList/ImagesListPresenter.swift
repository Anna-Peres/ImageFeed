//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 13.05.2025.
//

import Foundation

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    private let imagesListService = ImagesListService.shared

    func viewDidLoad() {
        updateImagesList()
        loadImages()
    }
    
    func updateImagesList() {
        imagesListService.imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let view = self?.view else { return }
                view.updateTableViewAnimated()
            }
    }
    
   func loadImages() {
        imagesListService.fetchPhotosNextPage { [weak self] error in
            if let error {
                print(error.localizedDescription)
            } else {
                self?.view?.tableView?.reloadData()
            }
        }
    }
}


