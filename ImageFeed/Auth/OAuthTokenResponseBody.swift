//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 29.03.2025.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
        
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
    
    static func decode(from data: Data) -> Result<OAuthTokenResponseBody, Error> {
        let decoder = JSONDecoder()
        do {
            let decodedResponse = try decoder.decode(OAuthTokenResponseBody.self, from: data)
            return .success(decodedResponse)
        } catch {
            print("Error in data decoding")
            return .failure(error)
        }
    }
}
