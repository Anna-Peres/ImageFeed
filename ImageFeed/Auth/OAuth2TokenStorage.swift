//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 29.03.2025.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: "authToken")
        }
        
        set {
            guard let newValue else { return }
            KeychainWrapper.standard.set(newValue, forKey: "authToken")
        }
    }
}
