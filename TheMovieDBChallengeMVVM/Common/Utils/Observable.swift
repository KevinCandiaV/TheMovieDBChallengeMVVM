//
//  Observable.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 19/08/23.
//

import Foundation

public struct ObservableCall<Input> {
    
    public init() {
        
    }
    
    private var callBack: ((Input)-> Void)?
    
    public mutating func bind<Observer: AnyObject>(to observer: Observer,
                                                   with callback: @escaping (Observer, Input)-> Void) {
        self.callBack = { [weak observer] input in
            guard let observer = observer else {
                return
            }
            callback(observer, input)
        }
    }
    
    public func notify(with input: Input) {
        callBack?(input)
    }

}
