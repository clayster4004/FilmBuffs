//
//  NetworkManager.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/14/24.
//

import Foundation

/// Enum for holding the types of errors possibly encountered
enum NetworkError: Error {
    case invalidURL
    case noData
}

class NetworkManager {
    // Singleton Pattern -> One instance of NetworkManager() for whole program
    static let shared = NetworkManager()
    
    private var apiKey: String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let key = plist["TMDbAPIKey"] as? String else {
            fatalError("API Key not found in Secrets.plist")
        }
        return key
    }
    
    // Holds the URL to themoviedb
    private let baseUrl = "https://api.themoviedb.org/3"

    private init() {}
    
    /// API call to search the database for results based on the user query;
    func searchMoviesAndActors(query: String, completion: @escaping (Result<[TMDbSearchResult], Error>) -> Void) {
        // Creates a URL swift object representing the endpoint I am looking to call
        guard let url = URL(string: "\(baseUrl)/search/multi?api_key=\(apiKey)&query=\(query)") else {
            // If that URL is invalid then completion is set to failure; holds invalidUrl error
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        // URLSession, used for queries, shared URLSession, singular request
        // Returns the data, response code, and error message. task is basically the "request in progress"
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // If there is an error message, set completion to failure
            if let error = error {
                completion(.failure(error))
                return
            }
            // If there is data, set it, if not set completion to failure
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            // Runs code that may throw an error
            do {
                // Decode the data into my TMDBSearchResponse object
                let results = try JSONDecoder().decode(TMDbSearchResponse.self, from: data)
                // On success set completion to an array of the decoded results
                completion(.success(results.results))
            // If there is an error, set completion to failure
            } catch {
                completion(.failure(error))
            }
        }
        // Required to send the request to the server
        task.resume()
    }
    
    // From the query, must be a list of "searchResults" -> Codable to be decodable from JSON
    struct TMDbSearchResponse: Codable {
        let results: [TMDbSearchResult]
    }

    struct TMDbSearchResult: Codable {
        let id: Int           // DB id
        let name: String?     // Actor name
        let title: String?    // Movie title
        let mediaType: String // movie, person, or tv
        let overview: String? // Description of movie or tvshow
        // Will hold a placeholder for biographies of a person, or overview for movie/tv
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
        // Maps the JSON to a swift object
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case title
            case mediaType = "media_type"
            case overview
        }
    }
    
    func fetchMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetails, Error>) -> Void) {
        // Set the URL for searching for a specific movie
        let url = URL(string: "\(baseUrl)/movie/\(movieId)?api_key=\(apiKey)")!
        // Request in progress
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            // If there is no data set completion to failure
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            // Code may run an error
            do {
                // Decode the movie details from the JSON
                let movieDetails = try JSONDecoder().decode(MovieDetails.self, from: data)
                completion(.success(movieDetails))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchActorDetails(actorId: Int, completion: @escaping (Result<ActorDetails, Error>) -> Void) {
        // Set the URL for searching for a specific person
        let url = URL(string: "\(baseUrl)/person/\(actorId)?api_key=\(apiKey)")!
        // Request in progress
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // If there is an error set completion to failure
            if let error = error {
                completion(.failure(error))
                return
            }
            // If there is no data set completion to failure
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            // Code may run an error
            do {
                // Decode the actor details from the JSON
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
        // Request in progress
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // If there is an error set completion to failure
            if let error = error {
                completion(.failure(error))
                return
            }
            // If there is no data set completion to failure
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            // Code may run an error
            do {
                // Decode the tvshow details from the JSON
                let tvShowDetails = try JSONDecoder().decode(TvShowDetails.self, from: data)
                completion(.success(tvShowDetails))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
