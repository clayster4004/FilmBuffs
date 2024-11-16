//
//  NetworkManager.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/14/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private var apiKey: String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let key = plist["TMDbAPIKey"] as? String else {
            fatalError("API Key not found in Secrets.plist")
        }
        return key
    }
    
    private let baseUrl = "https://api.themoviedb.org/3"

    private init() {}
    
    func searchMoviesAndActors(query: String, completion: @escaping (Result<[TMDbSearchResult], Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/search/multi?api_key=\(apiKey)&query=\(query)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TMDbSearchResponse.self, from: data)
                // let names = results.results.compactMap { $0.title ?? $0.name }
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }

        }
        task.resume()
    }
    
    struct TMDbSearchResponse: Codable {
        let results: [TMDbSearchResult]
    }

    struct TMDbSearchResult: Codable {
        let name: String?    // Actor name
        let title: String?   // Movie title
        let mediaType: String
        
        enum CodingKeys: String, CodingKey {
            case name
            case title
            case mediaType = "media_type"
        }
    }
    
    
}
