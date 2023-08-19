//
//  ViewController+Extensions.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 19/08/23.
//

import UIKit

// MARK: - Instance
public extension UIViewController {
    
    static func instantiate<T:UIViewController>() -> T {
        guard let storyboardName = String(describing: self).text(before: "ViewController") else {
            fatalError("The controller name is not standard.")
        }
        return instantiate(fromStoryboard: storyboardName)
    }
    
    static func instantiate<T:UIViewController>(fromStoryboard storyboardName:String) -> T {
        let bundle = Bundle(for: T.self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        let identifier = String(describing: T.self)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("The storyboard identifier does not exist.")
        }
        return viewController
    }
    
}

// MARK: - Child ViewController
public extension UIViewController {
    
    func insertChild(viewController: UIViewController, inView: UIView) {
        addChild(viewController)
        viewController.willMove(toParent: self)
        inView.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([inView.topAnchor.constraint(equalTo: viewController.view.topAnchor, constant: 0),
                                     inView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: 0),
                                     inView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor, constant: 0),
                                     inView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 0)])
        viewController.didMove(toParent: self)
    }
    
    func removeChild(viewController: UIViewController) {
        viewController.removeFromParent()
        viewController.willMove(toParent: nil)
        viewController.view?.removeFromSuperview()
        viewController.didMove(toParent: nil)
    }
    
}

// MARK: - Background
public extension UIViewController {
    
    func setBackground(withImage image:UIImage){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = image
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
    }
    
}


// MARK: adding custome methods
public protocol ConfigUIViewController {
    func setupNavController()
    func setupUI()
    func setupBuilding()
    func callWebServices()
    func setupDelegates()
}
