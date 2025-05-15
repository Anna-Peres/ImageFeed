//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 01.03.2025.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateAvatar()
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    // MARK: - Services
    private var profileService = ProfileService.shared
    private var profileImageService = ProfileImageService.shared
    private let storage = OAuth2TokenStorage()
    private var profileLogoutService = ProfileLogoutService.shared
    private let splashViewController = SplashViewController()
    var presenter: ProfilePresenterProtocol?
    
    // MARK: - UI Elements
    private var nameLabel = UILabel()
    private var loginNameLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var logoutButton = UIButton ()
    private var profileImageView = UIImageView()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        
        configureProfileImage()
        configureNameLabel()
        configureLoginNameLabel()
        configureDescriptionLabel()
        configureLogoutButton()
        updateProfileDetails()
        presenter?.viewDidLoad()
        updateAvatar()
    }
    
    func updateAvatar() {
        guard let profileImageURL = profileImageService.avatarURL else { return }
        let imageUrl = URL(string: profileImageURL)
        profileImageView.kf.setImage(with: imageUrl,
                                     placeholder: UIImage(named: "placeholder_for_profile"))
    }
    
    @IBAction private func didTapLogoutButton() {
        showLogoutAlert()
    }
    
    private func configureProfileImage() {
        let profileImage = UIImage(named: "Profile Image")
        profileImageView = UIImageView(image: profileImage)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func configureNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        let nameLabelStrokeTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.ypWhite,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 23),
        ]
        
        nameLabel.attributedText = NSMutableAttributedString(string: "Екатерина Новикова", attributes: nameLabelStrokeTextAttributes)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 105),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func configureLoginNameLabel() {
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        let loginNameLabelStrokeTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.ypGray,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
        ]
        
        loginNameLabel.attributedText = NSMutableAttributedString(string: "@ekaterina_nov", attributes: loginNameLabelStrokeTextAttributes)
        
        NSLayoutConstraint.activate([
            loginNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 136),
            loginNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        let descriptionLabelStrokeTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.ypWhite,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
        ]
        
        descriptionLabel.attributedText = NSMutableAttributedString(string: "Hello, world!", attributes: descriptionLabelStrokeTextAttributes)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 162),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func configureLogoutButton() {
        guard let logoutImage = UIImage(named: "Logout Image") else { return }
        logoutButton = UIButton.systemButton(
            with: logoutImage,
            target: self,
            action: #selector(Self.didTapLogoutButton)
        )
        view.addSubview(logoutButton)
        logoutButton.tintColor = .ypRed
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45)
        ])
    }
    
    private func updateProfileDetails() {
        guard storage.token != nil else {
            print("Authorization token not found")
            return
        }
        guard let profile = profileService.profile else { return }
        
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    private func switchToAuthViewController() {
        splashViewController.modalPresentationStyle = .fullScreen
        self.present(splashViewController, animated: true)
    }
    
    private func showLogoutAlert() {
        let alert = UIAlertController(title: "Пока, пока!",
                                                message: "Уверены, что хотите выйти?",
                                                preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { (action: UIAlertAction!) in
            self.profileLogoutService.logout()
            self.switchToAuthViewController()
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default))
        self.present(alert, animated: true)
    }
}
