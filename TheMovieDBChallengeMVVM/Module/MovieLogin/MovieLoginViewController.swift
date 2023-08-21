//
//  MovieLoginViewController.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 19/08/23.
//

import UIKit

class MovieLoginViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - ViewModel
    var viewModel: MovieLoginViewModelProtocol = MovieLoginViewModel()
    
    // MARK: - LoadNib
    static func loadFromNib() -> MovieLoginViewController {
        MovieLoginViewController(nibName: "MovieLoginViewController", bundle: nil)
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userTextField.text = "Admin"
        passwordTextField.text = "Password*123"
    }
    
    @objc func loginButtonTapped(_ button: UIButton) {
        print("Login Action")
        guard let user = userTextField.text, let pass = passwordTextField.text else {
            return
        }
        viewModel.login(user: user, password: pass)
    }
}

extension MovieLoginViewController: UITextFieldDelegate {
//    TODO Action for TextfieldDelegate
}

// MARK: - SetupUI
extension MovieLoginViewController {
    func setupUI() {
        // MARK: - Target Button
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        // MARK: - Delegates
        userTextField.delegate = self
        passwordTextField.delegate = self
    }
}

// MARK: - SetupBinding
extension MovieLoginViewController {
    func setupBinding() {
        self.viewModel.isLoading.bind(to: self) { (self, isLoading) in
            isLoading ? ActivityOverlay.show() : ActivityOverlay.dismiss()
        }
        
        self.viewModel.isSuccesLoginObservable.bind(to: self) { (self, isSuccess) in
            self.presentMovieListView()
        }
    }
}

// MARK: - Login To MovieList
extension MovieLoginViewController {
    func presentMovieListView() {
        let movieListViewController: MovieListViewController = MovieListViewController()
        self.navigationController?.pushViewController(movieListViewController, animated: true)
    }
}
