//
//  ViewController.swift
//  SmartGallery
//
//  Created by Ruchira  on 20/05/24.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var fullScreenImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = DogViewModel()
    var tapGestureRecognizer: UITapGestureRecognizer!
    
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
    }
    
    @objc func handleTap() {
           fullScreenImageView.isHidden = true
       }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.5)) // Adjust height to your needs
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        group.interItemSpacing = .fixed(1) // Adjust the spacing between items within a group
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 1 // Adjust the spacing between groups
        section.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1) // Adjust the padding around the section

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let imageUrl = viewModel.images[indexPath.item]
            if let url = URL(string: imageUrl) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self.fullScreenImageView.image = UIImage(data: data)
                            self.fullScreenImageView.isHidden = false
                        }
                    }
                }
            }
        }
}
