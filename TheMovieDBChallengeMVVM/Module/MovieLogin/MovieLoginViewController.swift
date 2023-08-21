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
    
    @IBOutlet weak var userMessageLabel: UILabel!
    @IBOutlet weak var passwordMessageLabel: UILabel!
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
        hideErrorMessages()
        guard let user = userTextField.text, let pass = passwordTextField.text else {
            return
        }
        viewModel.login(user: user, password: pass)
    }
}

// MARK: - SetupUI
extension MovieLoginViewController {
    func setupUI() {
        // MARK: - Target Button
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        // MARK: - Delegates
        userTextField.delegate = self
        passwordTextField.delegate = self
        
        // MARK: - Placeholder
        userTextField.placeholder = "Ingrese su usuario"
        passwordTextField.text = "Ingrese su password"
        
        userTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        
        userMessageLabel.isHidden = true
        passwordMessageLabel.isHidden = true
    }
    
    // MARK: - Animations
    func showErrorMessages() {
        UIView.animate(withDuration: 1, delay: 0.25, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.2) {
            self.userMessageLabel.isHidden = false
            self.passwordMessageLabel.isHidden = false
        }
    }
    
    func hideErrorMessages() {
        UIView.animate(withDuration: 1, delay: 0.1, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4) {
            self.userMessageLabel.isHidden = true
            self.passwordMessageLabel.isHidden = true
        }
    }
}

// MARK: - SetupBinding
extension MovieLoginViewController {
    func setupBinding() {
        self.viewModel.isLoading.bind(to: self) { (self, isLoading) in
            isLoading ? ActivityOverlay.show() : ActivityOverlay.dismiss()
        }
        
        self.viewModel.isSuccesLoginObservable.bind(to: self) { (self, isSuccess) in
            isSuccess ? self.presentMovieListView() : self.showErrorMessages()
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

extension MovieLoginViewController: UITextFieldDelegate {
//    TODO Action for TextfieldDelegate
}
