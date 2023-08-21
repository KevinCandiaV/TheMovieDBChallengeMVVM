//
//  MovieListViewModel.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 20/08/23.
//

import Foundation

protocol MovieListViewModelProtocol {
    // MARK: - Observables
    var isLoading: ObservableCall<Bool> { get set }
    var isSuccessMovieFetch: ObservableCall<MoviesModel?> { get set }
    
    // MARK: - Methods
    func getMovieList()
    
    var movies: MoviesModel? { get set }
    
}

class MovieListViewModel: MovieListViewModelProtocol {
    var currentPage = 1
    var totalPage = 0
    
    // MARK: - Observables
    var isLoading = ObservableCall<Bool>()
    var isSuccessMovieFetch = ObservableCall<MoviesModel?>()
    var movies: MoviesModel?
    
    func getMovieList() {
        let service = MovieRepository()
        totalPage = 0
        currentPage = 1
        let paging = "\(currentPage)"
        service.fetchMovies(page: paging) { [weak self] listOfMovies in
            guard let self = self else { return }
            self.isSuccessMovieFetch.notify(with: listOfMovies)
        }
    }
}
