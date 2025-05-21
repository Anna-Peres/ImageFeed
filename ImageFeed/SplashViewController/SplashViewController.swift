//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 01.04.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    // MARK: - Services
    private let storage = OAuth2TokenStorage()
    
    // MARK: - UI Elements
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    private var logoImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        
        configureImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = storage.token {
            fetchProfile(token)
        } else {
            // Show Auth Screen
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
            guard let authViewController = viewController else { return }
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: true)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func configureImage() {
        let logoImage = UIImage(named: "splash_screen_logo")
        logoImageView = UIImageView(image: logoImage)
        guard let logoImageView else { return }
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: 78),
            logoImageView.widthAnchor.constraint(equalToConstant: 75),
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController){
        vc.dismiss(animated: true)
        switchToTabBarController()
        
        guard let token = storage.token else {
            return
        }
        
        fetchProfile(token)
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        ProfileService.shared.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { result in
                    switch result {
                    case .success(let smallProfileImage):
                        print(smallProfileImage)
                    case .failure(let error):
                        print("[SplashViewController] - \(error.localizedDescription)")
                    }
                }
                self.switchToTabBarController()
            case .failure:
                print("Error loading profile")
                break
            }
        }
    }
}
