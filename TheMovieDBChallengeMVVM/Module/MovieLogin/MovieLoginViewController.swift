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
    
    func presentLoginView() {
        let movieListViewController = UIViewController()
        self.navigationController?.pushViewController(movieListViewController, animated: true)
    }

}

// MARK: - SetupUI
extension MovieLoginViewController {
    func setupUI() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
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
//            TODO Ir a otra vista
            print("Move to other view")
            self.presentLoginView()
        }
    }
}

extension MovieLoginViewController: UITextFieldDelegate {
    
}
