//
//  MovieRepository.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 20/08/23.
//

import Foundation

class MovieRepository {
    
    // MARK: - Get Movies
    func fetchMovies(page: String, completion: @escaping (MoviesModel?) -> Void) {
        let url = "\(Constants.fetchMoviesURL)\(Constants.api_Key)\(Constants.pageURL)\(page)"
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let postResponse = try decoder.decode(MoviesModel.self, from: data)
                    completion(postResponse)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
