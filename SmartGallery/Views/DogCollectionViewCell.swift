//
//  DogCollectionViewCell.swift
//  SmartGallery
//
//  Created by Ruchira  on 20/05/24.
//

import UIKit

class DogCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}
