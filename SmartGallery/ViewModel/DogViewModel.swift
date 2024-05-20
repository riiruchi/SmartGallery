//
//  DogViewModel.swift
//  SmartGallery
//
//  Created by Ruchira  on 20/05/24.
//

import Foundation

class DogViewModel {
    var images: [String] = []
    
    func fetchImages(completion: @escaping () -> Void) {
        let urlString = "https://dog.ceo/api/breeds/image/random/10"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
            do {
                let result = try JSONDecoder().decode(DogImageResponse.self, from: data)
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
