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
        let id: Int
        let name: String?    // Actor name
        let title: String?   // Movie title
        let mediaType: String
        let overview: String?
        // let biography: String?
        
        var description: String? {
            switch mediaType {
            case "person":
                return "Biography Available upon Selection"
            case "movie", "tv":
                return overview
            default:
                return nil
            }
        }
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case title
            case mediaType = "media_type"
            case overview
        }
    }
    
    func fetchMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetails, Error>) -> Void) {
        let url = URL(string: "\(baseUrl)/movie/\(movieId)?api_key=\(apiKey)")!
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
                let movieDetails = try JSONDecoder().decode(MovieDetails.self, from: data)
                completion(.success(movieDetails))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchActorDetails(actorId: Int, completion: @escaping (Result<ActorDetails, Error>) -> Void) {
        let url = URL(string: "\(baseUrl)/person/\(actorId)?api_key=\(apiKey)")!
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
                let actorDetails = try JSONDecoder().decode(ActorDetails.self, from: data)
                completion(.success(actorDetails))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchTvShowDetails(tvShowId: Int, completion: @escaping (Result<TvShowDetails, Error>) -> Void) {
        let url = URL(string: "\(baseUrl)/tv/\(tvShowId)?api_key=\(apiKey)")!
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
                let tvShowDetails = try JSONDecoder().decode(TvShowDetails.self, from: data)
                completion(.success(tvShowDetails))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
