//
//  Constants.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 21.03.2025.
//
import Foundation

enum Constants {
    static let accessKey = "fQLwN2u5DvslonGQq2_x2ARQWoEBIzG_mUVP-nmOOFw"
    static let secretKey = "d65o53bGWbLgUkIp7xrxmGF6OdUkN-3UeuwDJYWBCZk"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        AuthConfiguration(accessKey: Constants.accessKey,
                          secretKey: Constants.secretKey,
                          redirectURI: Constants.redirectURI,
                          accessScope: Constants.accessScope,
                          authURLString: Constants.unsplashAuthorizeURLString,
                          defaultBaseURL: Constants.defaultBaseURL)
    }
}
