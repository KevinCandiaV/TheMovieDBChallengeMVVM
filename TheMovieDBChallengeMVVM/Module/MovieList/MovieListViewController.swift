//
//  MovieListViewController.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 20/08/23.
//

import UIKit

class MovieListViewController: UIViewController {
    // MARK: - Properties
    let movieListTableView = UITableView()
    
    // MARK: - ViewModel
    var viewModel: MovieListViewModelProtocol = MovieListViewModel()
    
    var movieList: [MovieModel]?
    
    // MARK: - LifeCycle
    override func loadView() {
        super.loadView()
        setupUI()
        setupBinding()
        callWebService()
    }
    
    func callWebService() {
        viewModel.getMovieList()
    }
    
    func reloadMovieData(withMovie movies: MoviesModel?) {
        self.movieList = movies?.results
        DispatchQueue.main.async {
            self.movieListTableView.reloadData()
        }
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
//        movieListTableView.rowHeight = 200
        
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
        
        if (offSetY + scrollView.frame.size.height > contentHeight) {
            print("llamar mas")
        }
    }
}

// MARK: - UITableViewDelegate
extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ir a detalle")
        guard let movie = movieList?[indexPath.row] else { return }
        presentDetailView(withMovie: movie)
    }
}
