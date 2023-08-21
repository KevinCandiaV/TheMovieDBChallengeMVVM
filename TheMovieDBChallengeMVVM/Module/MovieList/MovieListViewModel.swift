//
//  MovieListViewModel.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 20/08/23.
//

import UIKit
import Alamofire

protocol MovieListViewModelProtocol {
    // MARK: - Observables
    var isLoading: ObservableCall<Bool> { get set }
    var isSuccessMovieFetch: ObservableCall<MoviesModel?> { get set }
    var isSuccesMoreMovies: ObservableCall<MoviesModel?> { get set }
    var isSuccessCoreDataMovieFetch: ObservableCall<[MovieModel]?> { get set }
    
    // MARK: - Methods
    func getMovieList()
    func getMoreMovies(isLast index: Bool)
    func saveMovieInCoreData(movieList: MoviesModel)
    func getMovieListCoreData()
    
    var movies: MoviesModel? { get set }
    
}

class MovieListViewModel: MovieListViewModelProtocol {
    var currentPage = 1
    var totalPage = 0
    
    // MARK: - Observables
    var isLoading = ObservableCall<Bool>()
    var isSuccessMovieFetch = ObservableCall<MoviesModel?>()
    var isSuccesMoreMovies = ObservableCall<MoviesModel?>()
    var isSuccessCoreDataMovieFetch = ObservableCall<[MovieModel]?>()
    
    var movies: MoviesModel?
    
    func getMovieList() {
        let service = MovieRepository()
        totalPage = 0
        currentPage = 1
        let paging = "\(currentPage)"
        service.fetchMovies(page: paging) { [weak self] listOfMovies in
            guard let self = self else { return }
            totalPage = listOfMovies?.totalPages ?? 0
            currentPage = listOfMovies?.page ?? 0
            guard let listOfMovies = listOfMovies else { return }
            self.isSuccessMovieFetch.notify(with: listOfMovies)
        }
    }
    
    func getMoreMovies(isLast last: Bool) {
        let service = MovieRepository()
        if currentPage < totalPage {
            currentPage += 1
            let paging = "\(currentPage)"
            service.fetchMovies(page: paging) { [weak self] listOfMovies in
                guard let self = self else { return }
                self.isSuccesMoreMovies.notify(with: listOfMovies)
            }
            
        }
    }
    
    func saveMovieInCoreData(movieList: MoviesModel) {
        let service = CoreDataRepository()
        guard let movies = movieList.results else { return }
        movies.forEach { item in
            DispatchQueue.main.async {
                service.downloadPoster(withPath: item.posterPath ?? "") { posterImage in
                    guard let posterImage = posterImage else { return }
                    service.saveMovie(withMovie: item, withImage: posterImage)
                }
                service.saveMovie(withMovie: item, withImage: UIImage())
            }
        }
    }
    
    func getMovieListCoreData() {
        let service = CoreDataRepository()
        service.fetchCoraDataMovies { [weak self] movieListOfCoreData in
            guard let self = self else { return }
            let tempList = wrapLidtMoviesDBInDataModel(listCoreData: movieListOfCoreData)
            isSuccessCoreDataMovieFetch.notify(with: tempList)
        }
    }
    
    func wrapLidtMoviesDBInDataModel(listCoreData: [MoviesCoreData]) -> [MovieModel] {
        var listMovies = [MovieModel]()
        listCoreData.forEach {
            (item) in
            var movie = MovieModel()
            movie.id = Int(item.id)
            movie.overview = item.overview
            movie.posterPath = item.posterPath
            movie.releaseDate = item.release_date
            movie.title = item.title
            movie.voteAverage = item.vote_average
            
            listMovies.append(movie)
        }
        return listMovies
    }
}
