//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 28.04.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as! ImagesListViewController
        let imagesListPresenter = ImagesListPresenter()
        imagesListViewController.presenter = imagesListPresenter
        
        imagesListViewController.tabBarItem = UITabBarItem(
                       title: "",
                       image: UIImage(named: "tab_editorial_active"),
                       selectedImage: nil
                   )
        imagesListViewController.tabBarItem.accessibilityIdentifier = "ImagesListTab"
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
                       title: "",
                       image: UIImage(named: "tab_profile_active"),
                       selectedImage: nil
                   )
        profileViewController.tabBarItem.accessibilityIdentifier = "ProfileTab"
      
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
