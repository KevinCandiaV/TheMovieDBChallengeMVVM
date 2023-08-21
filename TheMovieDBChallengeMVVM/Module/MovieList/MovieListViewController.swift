//
//  MovieListViewController.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 20/08/23.
//

import UIKit
import Network

class MovieListViewController: UIViewController {
    // MARK: - Properties
    let movieListTableView = UITableView()
    
    // MARK: - ViewModel
    var viewModel: MovieListViewModelProtocol = MovieListViewModel()
    
    var movieList: [MovieModel]?
    
    var lastMovieIndex = false
    
    // MARK: - Network check
    var networkCheck = NetworkCheck.sharedInstance()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        networkCheck.addObserver(observer: self)
        setupUI()
        setupBinding()
        callWebService()
    }
    
    func callWebService() {
        viewModel.getMovieList()
    }
}

// MARK: - SetupUI
extension MovieListViewController {
    func setupUI() {
        // MARK: View
        view.backgroundColor = .white
        title = "The MovieDB"
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.prefersLargeTitles = true
        // MARK: MovieListConstraints
        view.addSubview(movieListTableView)
        
        movieListTableView.translatesAutoresizingMaskIntoConstraints = false
        movieListTableView.fillSuperview()
        movieListTableView.rowHeight = 260
        
        // MARK: Nib Load
        let cellNib = UINib(nibName: MovieListTableViewCell.reusableIdentifier, bundle: nil)
        
        // MARK: Register Nib
        movieListTableView.register(cellNib, forCellReuseIdentifier: MovieListTableViewCell.reusableIdentifier)
        
        // MARK: Delegate
        movieListTableView.dataSource = self
        movieListTableView.delegate = self
    }
}

// MARK: - SetupBinding
extension MovieListViewController {
    func setupBinding() {
        self.viewModel.isLoading.bind(to: self) { (self, isLoading) in
            isLoading ? ActivityOverlay.show() : ActivityOverlay.dismiss()
        }
        
        self.viewModel.isSuccessMovieFetch.bind(to: self) { (self, movies) in
            self.reloadMovieData(withMovie: movies)
        }
        
        self.viewModel.isSuccesMoreMovies.bind(to: self) { (self, moreMovies) in
            self.reloadMoreMoviesData(withMovies: moreMovies)
        }
        
        self.viewModel.isSuccessCoreDataMovieFetch.bind(to: self) { (self, coreDataMovies) in
            self.reloadCoreData(withMovie: coreDataMovies)
        }
    }
}

// MARK: - Reload Data
extension MovieListViewController {
    func reloadMovieData(withMovie movies: MoviesModel?) {
        self.movieList = movies?.results
        DispatchQueue.main.async {
            self.movieListTableView.reloadData()
            self.viewModel.saveMovieInCoreData(movieList: movies!)
        }
    }
    
    func reloadMoreMoviesData(withMovies movies: MoviesModel?) {
        self.lastMovieIndex = false
        self.movieList?.append(contentsOf: (movies?.results)!)
        DispatchQueue.main.async {
            self.movieListTableView.reloadData()
        }
    }
    
    func reloadCoreData(withMovie movies: [MovieModel]?) {
        self.movieList?.removeAll()
        self.movieList = movies
        DispatchQueue.main.async {
            self.movieListTableView.reloadData()
        }
    }
}

// MARK: - List To MovieDetail
extension MovieListViewController {
    func presentDetailView(withMovie movie: MovieModel) {
        let movieListViewController: MovieDetailViewController = MovieDetailViewController.instantiate()
        movieListViewController.data = movie
        self.navigationController?.pushViewController(movieListViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieListTableViewCell.reusableIdentifier, for: indexPath) as? MovieListTableViewCell else {
            return UITableViewCell()
        }
        
        let data = movieList?[indexPath.row]
        cell.data = data
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offSetY + scrollView.frame.size.height > contentHeight) && !lastMovieIndex {
            if !self.lastMovieIndex {
                self.lastMovieIndex = false
                viewModel.getMoreMovies(isLast: lastMovieIndex)
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = movieList?[indexPath.row] else { return }
        presentDetailView(withMovie: movie)
    }
}

// MARK: - Network Delegate
extension MovieListViewController: NetworkCheckObserver {
    func statusDidChange(status: NWPath.Status) {
        if status == .satisfied {
            movieList?.removeAll()
            DispatchQueue.main.async {
                self.movieListTableView.reloadData()
            }
            viewModel.getMovieList()
        }else if status == .unsatisfied {
            movieList?.removeAll()
            DispatchQueue.main.async {
                self.movieListTableView.reloadData()
            }
            viewModel.getMovieListCoreData()
        }
    }
}
