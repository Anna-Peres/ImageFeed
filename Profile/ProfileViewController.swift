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
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        let nameLabelStrokeTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.ypWhite,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 23),
        ] as! [NSAttributedString.Key : Any]
        
        nameLabel.attributedText = NSMutableAttributedString(string: "Екатерина Новикова", attributes: nameLabelStrokeTextAttributes)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor)
        ])
        
        let loginNameLabel = UILabel()
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        let loginNameLabelStrokeTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.ypGray,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
        ]
        
        loginNameLabel.attributedText = NSMutableAttributedString(string: "@ekaterina_nov", attributes: loginNameLabelStrokeTextAttributes)
        
        NSLayoutConstraint.activate([
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor)
        ])
        
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        let descriptionLabelStrokeTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.ypWhite,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
        ] as! [NSAttributedString.Key : Any]
        
        descriptionLabel.attributedText = NSMutableAttributedString(string: "Hello, world!", attributes: descriptionLabelStrokeTextAttributes)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor)
        ])
        
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
            logoutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
            ])
    }
    
    @IBAction private func didTapLogoutButton() {
        // TODO:
    }
}
