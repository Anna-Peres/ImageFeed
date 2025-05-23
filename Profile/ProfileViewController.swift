//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 01.03.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        configureProfileImage()
        configureNameLabel()
        configureLoginNameLabel()
        configureDescriptionLabel()
        configureLogoutButton()
    }
    
    @IBAction private func didTapLogoutButton() {
        // TODO:
    }
    
    private func configureProfileImage() {
        let profileImage = UIImage(named: "Profile Image")
        let profileImageView = UIImageView(image: profileImage)
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
        let nameLabel = UILabel()
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
        let loginNameLabel = UILabel()
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
        let descriptionLabel = UILabel()
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
        let logoutButton = UIButton.systemButton(
            with: UIImage(named: "Logout Image")!,
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
}
