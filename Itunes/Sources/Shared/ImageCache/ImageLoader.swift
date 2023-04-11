//
//  ImageLoader.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 01/09/22.
//

import Foundation
import UIKit

// Image loader class to load images from url and showing in UIImageView
final class ImageLoader {
    private var loadedImages = [URL: UIImage]()
    private var runningRequests = [UUID: URLSessionDataTask]()

    func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        // If image is already downloaded for the URL, return image.
        if let image = loadedImages[url] {
            completion(.success(image))
            return nil
        }
        // UUID used to uniquely identify each data task later on
        let uuid = UUID()
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            // removing request form runningRequests when completed
            defer { self?.runningRequests.removeValue(forKey: uuid) }

            if let data = data, let image = UIImage(data: data) {
                self?.loadedImages[url] = image
                completion(.success(image))
                return
            }

            guard let error = error else { return }
            guard (error as NSError).code == NSURLErrorCancelled else {
                completion(.failure(error))
                return
            }
            // the request was cancelled, no need to call the callback
        }
        task.resume()
        runningRequests[uuid] = task
        return uuid
    }

    // Cancel the ongoing request.
    func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
}

// Singleton class to load any image for UIImageview
final class UIImageLoader {
    static let loader = UIImageLoader()

    private let imageLoader = ImageLoader()
    private var uuidMap = [UIImageView: UUID]()

    private init() {}

    func load(_ url: URL, for imageView: UIImageView) {
        let token = imageLoader.loadImage(url) { [weak self] result in
            // removing request form uuidMap when completed
            defer { self?.uuidMap.removeValue(forKey: imageView) }
            do {
                let image = try result.get()
                DispatchQueue.main.async {
                    imageView.image = image
                }
            } catch {
                // handle the error
            }
        }
        if let token = token {
            uuidMap[imageView] = token
        }
    }

    func cancel(for imageView: UIImageView) {
        if let uuid = uuidMap[imageView] {
            imageLoader.cancelLoad(uuid)
            uuidMap.removeValue(forKey: imageView)
        }
    }
}
