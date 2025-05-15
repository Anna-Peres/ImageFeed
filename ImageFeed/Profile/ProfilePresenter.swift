//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 13.05.2025.
//

import Foundation

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateAvatarUrl() -> URL?
    func getProfile() -> Profile?
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    private var profileImageService = ProfileImageService.shared
    private var profileService = ProfileService.shared
    
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
    
    func updateAvatarUrl() -> URL? {
        guard let profileImageURL = profileImageService.avatarURL else { return URL(string: "https://api.unsplash.com") }
        let imageUrl = URL(string: profileImageURL)
        return imageUrl
    }
    
    func getProfile() -> Profile? {
        let profile = profileService.profile
        return profile
    }
}
