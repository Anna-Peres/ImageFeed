//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 13.05.2025.
//

import Foundation

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
}
