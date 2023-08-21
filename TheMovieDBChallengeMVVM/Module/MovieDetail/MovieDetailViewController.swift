//
//  MovieDetailViewController.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 20/08/23.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    // MARK: - ViewModel
    var viewModel: MovieDetailViewModelProtocol = MovieDetailViewModel()
    
    // MARK: - Model
    var data: MovieModel?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        viewModel.validateData(witData: data)
    }
    
    func setData(withMovie movie: MovieModel) {
        titleLabel.text = movie.title
        dateLabel.text = movie.releaseDate
        averageLabel.text = String(movie.voteAverage ?? 0)
        overviewLabel.text = movie.overview
        posterImageView.af.setImage(withURL: getUrl(movie.posterPath!))
    }
}

// MARK: - SetupUI
extension MovieDetailViewController {
    func setupUI() {
        title = "Detail"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - SetupBinding
extension MovieDetailViewController {
    func setupBinding() {
        viewModel.isMovieData.bind(to: self) { (self, movie) in
            self.setData(withMovie: movie)
        }
    }
}
