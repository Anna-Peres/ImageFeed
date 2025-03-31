//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 29.03.2025.
//

import Foundation

final class OAuth2TokenStorage {
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: "authToken")
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "authToken")
        }
    }
}
