//
//  DogImage.swift
//  SmartGallery
//
//  Created by Ruchira  on 20/05/24.
//

import Foundation

/// A structure that represents the response from the Dog API.
struct ApiImageResponse: Codable {
    /// An array of image URLs.
    let message: [String]
    /// A status message indicating the result of the API call.
    let status: String
}
