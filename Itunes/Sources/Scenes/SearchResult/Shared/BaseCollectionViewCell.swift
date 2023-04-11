//
//  BaseCollectionViewCell.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 02/09/22.
//

import UIKit

/// Base collection cell
class BaseCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak private var artWorkImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        artWorkImageView.image = UIImage(systemName: "photo.artframe")
        artWorkImageView.cancelImageLoad()
    }

    /// Set Artwork data in cell componentsl
    /// - Parameter artwork: ArtWorkDisplayProtocol
    func setData(artwork: ArtWorkDisplayProtocol) {
        titleLabel.text = artwork.artistName
        guard let artWorkUrlString = artwork.artworkUrl, let imageUrl = URL(string: artWorkUrlString) else { return }
        artWorkImageView.loadImage(at: imageUrl)
    }
}
