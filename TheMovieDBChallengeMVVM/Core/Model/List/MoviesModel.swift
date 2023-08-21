//
//  MoviesModel.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 20/08/23.
//

import Foundation

struct MoviesModel: Codable {
    var dates: Dates?
    var page: Int?
    var results: [MovieModel]?
    var totalPages: Int?
    var totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case dates = "dates"
        case results = "results"
        case page = "page"
        case totalPages = "total_pages"
    }
    
    public init() { }
}

// MARK: - Dates
struct Dates: Codable{
    let maximum: String?
    let minimum: String?
}


// MARK: - Result
struct MovieModel: Codable {
    var id: Int?
    var title: String?
    var releaseDate: String?
    var voteAverage: Double?
    var overview: String?
    var posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case overview = "overview"
        case posterPath = "poster_path"
    }
    
    public init() { }
    
}
