//
//  ServiceManager.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 31/08/22.
//

import Foundation

/// Api methods
enum APIMethod: String {
    case get = "GET"
    case post = "POST"
}

/// Enum for end point's
enum Endpoint: String {
    case search = "/search"
}

// Configuration Enum
enum Configuration: String {
    case baseUrl = "https://itunes.apple.com"
}

/// API error's enum
enum APIError: Error {
    case unknown
}

/// ServiceManager for network calls
final class ServiceManager {

    static let shared = ServiceManager()
    private init() { }
    /// Create the URL request
    /// - Parameters:
    ///   - endPoint: request end point
    ///   - method: request type 'Post' or 'Get'
    ///   - params: request parameter
    /// - Returns: URLRequest?
    private func getURLRequest(_ endPoint: Endpoint, method: APIMethod, params: [String: Any]) -> URLRequest? {
        var urlString = Configuration.baseUrl.rawValue + endPoint.rawValue
        var urlRequest: URLRequest?

        switch method {
        case .get:
            urlString += ("?" + params.map { "\($0)=\($1)" }
                            .joined(separator: "&"))
            guard let url = URL(string: urlString) else { return nil }
            urlRequest = URLRequest(url: url)
        case .post:
            guard let url = URL(string: urlString) else { return nil }
            urlRequest = URLRequest(url: url)
            if method == .post {
                urlRequest?.httpBody = try? JSONSerialization.data(withJSONObject: params)
            }
        }

        urlRequest?.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest?.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest?.httpMethod = method.rawValue
        return urlRequest
    }

    /// Make the network call and call completion on end.
    func getResults<T: Decodable>(_ model: T.Type,
                                  endPoint: Endpoint,
                                  method: APIMethod,
                                  params: [String: Any],
                                  completion: @escaping (Result<T, Error>) -> Void) {
        guard let request = getURLRequest(endPoint, method: method, params: params) else {
            completion(.failure(APIError.unknown))
            return
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(APIError.unknown))
                return
            }
            // Check if response status code is valid and data is not nil
            if (200...299).contains(response.statusCode), let responseData = data {
                do {
                    let json = try JSONDecoder().decode(T.self, from: responseData)
                    completion(.success(json))
                } catch {
                    print("Error during JSON serialization: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(APIError.unknown))
            }
        }.resume()
    }
}
