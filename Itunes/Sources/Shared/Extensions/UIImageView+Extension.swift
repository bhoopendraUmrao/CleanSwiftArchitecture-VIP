//
//  UIImageView+Extension.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 02/09/22.
//

import UIKit

// MARK: - UIImageView extension to load and cancel images from url.
extension UIImageView {
    func loadImage(at url: URL) {
        UIImageLoader.loader.load(url, for: self)
    }

    func cancelImageLoad() {
        UIImageLoader.loader.cancel(for: self)
    }
}
