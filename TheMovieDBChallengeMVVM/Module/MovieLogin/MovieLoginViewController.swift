//
//  MovieLoginViewController.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 19/08/23.
//

import UIKit

class MovieLoginViewController: UIViewController {
    
    // MARK: - Properties
    
    
    // MARK: - ViewModel
    var viewModel: MovieLoginViewModelProtocol = MovieLoginViewModel()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()

    }

}

extension MovieLoginViewController {
    func setupUI() {
        
    }
}

extension MovieLoginViewController {
    func setupBinding() {
//        self.viewModel.isLoading.bind(to: self) { (self, isLoading) in
//            isLoading ? 
//        }
    }
}
