//
//  Untitled.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 16.04.2025.
//

import Foundation

struct ProfileResult: Decodable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
    
    static func decode(from data: Data) -> Result<ProfileResult, Error> {
        let decoder = JSONDecoder()
        do {
            let decodedResponse = try decoder.decode(ProfileResult.self, from: data)
            return .success(decodedResponse)
        } catch {
            print("Error in data decoding")
            return .failure(error)
        }
    }
}

