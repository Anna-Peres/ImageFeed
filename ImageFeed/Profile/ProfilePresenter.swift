//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 13.05.2025.
//

import Foundation

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        print("ProfilePresenter loaded")
        updateProfile()
    }
    
    func updateProfile() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard (self?.view) != nil else { return }
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    print("Updating avatar")
                    self.view?.updateAvatar()
                }
            }
    }
}
