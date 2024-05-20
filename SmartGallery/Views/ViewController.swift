//
//  ViewController.swift
//  SmartGallery
//
//  Created by Ruchira  on 20/05/24.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    /// The collection view that displays the dog images.
    @IBOutlet weak var collectionView: UICollectionView!
    /// The visual effect view that provides a blur effect when an image is displayed in full screen.
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    /// The image view that displays the selected dog image in full screen.
    @IBOutlet weak var fullScreenImageView: UIImageView!
    /// The view model that manages fetching and storing dog images.
    let viewModel = DogViewModel()
    /// A tap gesture recognizer for dismissing the full screen image view.
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    /// This method sets up the collection view data source and delegate, configures the
    /// collection view layout, initializes the tap gesture recognizer, and starts fetching
    /// the dog images from the remote API.
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
            collectionView.delegate = self
        collectionView.collectionViewLayout = createLayout()
                
        viewModel.fetchImages {
            self.collectionView.reloadData()
        }
        
        // Initialize tap gesture recognizer
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        fullScreenImageView.addGestureRecognizer(tapGestureRecognizer)
        fullScreenImageView.isUserInteractionEnabled = true
        fullScreenImageView.isHidden = true
        blurEffectView.isHidden = true
    }
    
    /// Handles the tap gesture to dismiss the full screen image view.
    @objc func handleTap() {
        fullScreenImageView.isHidden = true
        blurEffectView.isHidden = true
    }
    
    /// Creates the compositional layout for the collection view.
    ///
    /// This method defines the layout for the collection view using a compositional layout
    /// that supports different item sizes and group configurations.
    ///
    /// - Returns: A `UICollectionViewLayout` object that defines the collection view layout.
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            return self.createSectionLayout()
        }
        return layout
    }
    
    /// Creates the section layout for the compositional layout.
    ///
    /// This method defines the item sizes and group configurations for the section layout,
    /// including small, medium, and large items and groups.
    ///
    /// - Returns: A `NSCollectionLayoutSection` object that defines the section layout.
    func createSectionLayout() -> NSCollectionLayoutSection {
        // Item sizes
        let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                       heightDimension: .fractionalHeight(1.0))
        let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
        smallItem.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
            
        let mediumItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .fractionalHeight(0.5))
        let mediumItem = NSCollectionLayoutItem(layoutSize: mediumItemSize)
        mediumItem.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
            
        let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalHeight(1.0))
        let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
        largeItem.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
            
        // Groups
        let smallGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .fractionalWidth(0.5))
        let smallGroup = NSCollectionLayoutGroup.horizontal(layoutSize: smallGroupSize, subitems: [smallItem, smallItem])
            
        let mediumGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                         heightDimension: .fractionalWidth(1.0))
        let mediumGroup = NSCollectionLayoutGroup.vertical(layoutSize: mediumGroupSize, subitems: [mediumItem, mediumItem])
            
        let mixedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .fractionalWidth(1.0))
        let mixedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: mixedGroupSize, subitems: [largeItem, mediumGroup])
            
        let sectionGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .estimated(400))
        let sectionGroup = NSCollectionLayoutGroup.vertical(layoutSize: sectionGroupSize, subitems: [smallGroup, smallGroup, mixedGroup, smallGroup])
            
        let section = NSCollectionLayoutSection(group: sectionGroup)
        return section
    }
    
    /// Returns the number of items in the specified section.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count
    }
    
    /// Returns the cell for the item at the specified index path.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->              UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogCell", for: indexPath) as! DogCollectionViewCell
        let imageUrl = viewModel.images[indexPath.item]
        if let url = URL(string: imageUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        cell.imageView.image = UIImage(data: data)
                    }
                }
            }
        }
        return cell
    }
    
    /// Handles the selection of an item in the collection view.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageUrl = viewModel.images[indexPath.item]
            if let url = URL(string: imageUrl) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self.fullScreenImageView.image = UIImage(data: data)
                            self.blurEffectView.isHidden = false
                            self.fullScreenImageView.isHidden = false
                        }
                    }
                }
            }
    }
}
