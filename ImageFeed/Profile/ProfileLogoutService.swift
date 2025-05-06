//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 06.05.2025.
//

import Foundation
import WebKit
import SwiftKeychainWrapper

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    private var profileService = ProfileService.shared
    private var profileImageService = ProfileImageService.shared
    private var imagesListService = ImagesListService.shared
    
    private init() { }
    
    func logout() {
        cleanCookies()
        cleanData()
        cleanToken()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func cleanData () {
        profileService.cleanProfile()
        profileImageService.cleanProfileImage()
        imagesListService.cleanImages()
    }
    
    private func cleanToken() {
        KeychainWrapper.standard.removeObject(forKey: "authToken")
    }
}

