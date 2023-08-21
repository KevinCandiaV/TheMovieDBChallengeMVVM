//
//  MovieLoginViewModel.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 19/08/23.
//

import Foundation

protocol MovieLoginViewModelProtocol {
    // MARK: - Observables
    var isLoading: ObservableCall<Bool> { get set }
    var isSuccesLoginObservable: ObservableCall<Bool> { get set }
    
    // MARK: - Methods
    func login(user: String, password: String)
    
}

class MovieLoginViewModel: MovieLoginViewModelProtocol {
    
    // MARK: - Observables
    var isLoading = ObservableCall<Bool>()
    var isSuccesLoginObservable = ObservableCall<Bool>()
    
    func login(user: String, password: String) {
        defer {
            isLoading.notify(with: false)
        }
        isLoading.notify(with: true)
        guard user == "Admin" , password == "Password*123" else {
            isSuccesLoginObservable.notify(with: false)
            return
        }
        isSuccesLoginObservable.notify(with: true)
    }
}
