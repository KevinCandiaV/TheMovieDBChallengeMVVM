//
//  CoreDateRepository.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 20/08/23.
//

import UIKit

class CoreDataRepository {
    let context = AppDelegate.shared.persistentContainer.viewContext
    
    func saveMovie(withMovie movie: MovieModel, withImage image: UIImage) {
        let newMovie = MoviesCoreData(context: context)
        newMovie.id = Int32(movie.id!.description)!
        newMovie.title = movie.title
        newMovie.overview = movie.overview
        newMovie.posterPath = movie.posterPath
        newMovie.release_date = movie.releaseDate
        newMovie.vote_average = movie.voteAverage ?? 0.0
        newMovie.imagePoster = image.pngData()

        do {
            try context.save()
            print("pelicula guardada \(String(describing: movie.id?.description))")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchCoraDataMovies(completion: @escaping ([MoviesCoreData]) -> Void) {
        do {
            let movies = try context.fetch(MoviesCoreData.fetchRequest())
            completion(movies)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func downloadPoster(withPath path: String, completion: @escaping (UIImage?) -> Void) {
        var imageRec: UIImage?
        let dataTask = URLSession.shared.dataTask(with: getUrl(path)) { (data, response, error) in
            if let data = data {
                imageRec = UIImage(data: data)
                completion(imageRec)
            }
        }
        dataTask.resume()
    }
}
