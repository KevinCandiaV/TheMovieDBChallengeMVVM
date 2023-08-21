//
//  MovieDetailViewModel.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 20/08/23.
//

import Foundation

protocol MovieDetailViewModelProtocol {
    // MARK: - Observable
    var isMovieData: ObservableCall<MovieModel> { get set }
    
    // MARK: - Methods
    func validateData(witData data: MovieModel?)
}

class MovieDetailViewModel: MovieDetailViewModelProtocol {
    // MARK: - Observable
    var isMovieData = ObservableCall<MovieModel>()
    
    // MARK: - Methods
    func validateData(witData data: MovieModel?) {
        guard let data = data else { return }
        guard let _ = data.posterPath, let _ = data.title, let _ = data.releaseDate, let _ = data.voteAverage, let _ = data.overview else { return }
        isMovieData.notify(with: data)
    }
}
