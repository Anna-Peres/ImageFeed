//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 01.03.2025.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private var profileService = ProfileService.shared
    private var profileImageService = ProfileImageService.shared
    private let storage = OAuth2TokenStorage()
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private var nameLabel: UILabel?
    private var loginNameLabel: UILabel?
    private var descriptionLabel: UILabel?
    private var logoutButton: UIButton?
    private var profileImageView: UIImageView?
    
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
        
        guard storage.token != nil else {
            print("Authorization token not found")
            return
        }
        updateProfileDetails()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    @IBAction private func didTapLogoutButton() {
        // TODO:
    }
    
    private func configureProfileImage() {
        let profileImage = UIImage(named: "Profile Image")
        profileImageView = UIImageView(image: profileImage)
        guard let profileImageView else { return }
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
        nameLabel = UILabel()
        guard let nameLabel else { return }
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
        loginNameLabel = UILabel()
        guard let loginNameLabel else { return }
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
        descriptionLabel = UILabel()
        guard let descriptionLabel else { return }
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
        logoutButton = UIButton.systemButton(
            with: UIImage(named: "Logout Image")!,
            target: self,
            action: #selector(Self.didTapLogoutButton)
        )
        guard let logoutButton else { return }
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
        guard let profile = profileService.profile else { return }
        
        guard let nameLabel else { return }
        nameLabel.text = profile.name
        
        guard let loginNameLabel else { return }
        loginNameLabel.text = profile.loginName
        
        guard let descriptionLabel else { return }
        descriptionLabel.text = profile.bio
    }
    
    private func updateAvatar() {
        guard let profileImageURL = profileImageService.avatarURL,
              let profileImageView = profileImageView
        else { return }
        let imageUrl = URL(string: profileImageURL)
        profileImageView.kf.setImage(with: imageUrl,
                                     placeholder: UIImage(named: "placeholder.jpeg"))
    }
}
