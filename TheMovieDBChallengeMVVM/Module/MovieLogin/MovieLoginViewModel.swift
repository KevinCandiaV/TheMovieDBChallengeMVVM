//
//  MovieLoginViewModel.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 19/08/23.
//

import Foundation

protocol MovieLoginViewModelProtocol {
    var isLoading: ObservableCall<Bool> { get set }
}

class MovieLoginViewModel: MovieLoginViewModelProtocol {
    
    var isLoading = ObservableCall<Bool>()
    
    
}
