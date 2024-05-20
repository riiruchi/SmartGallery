//
//  DogCollectionViewCell.swift
//  SmartGallery
//
//  Created by Ruchira  on 20/05/24.
//

import UIKit

/// A custom collection view cell that displays a dog image.
class DogCollectionViewCell: UICollectionViewCell {
    
    /// The image view that displays the dog image.
    @IBOutlet weak var imageView: UIImageView!
    
    /// This method sets the content mode of the image view to `scaleAspectFill`
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}
