//
//  DogViewModel.swift
//  SmartGallery
//
//  Created by Ruchira  on 20/05/24.
//

import Foundation

/// The `DogViewModel` class is responsible for managing the data related to
/// dog images. It provides a method to fetch images from a remote API and
/// stores the image URLs in an array.
class DogViewModel {
    /// An array of image URLs.
    var images: [String] = []
    
    /// Fetches dog images from the remote API.
    func fetchImages(completion: @escaping () -> Void) {
        let urlString = "https://dog.ceo/api/breeds/image/random/20"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
            do {
                let result = try JSONDecoder().decode(ApiImageResponse.self, from: data)
                self.images = result.message
                DispatchQueue.main.async {
                        completion()
                }
            } catch {
                print("Failed to decode JSON:", error)
               }
            }
        }.resume()
    }
}
