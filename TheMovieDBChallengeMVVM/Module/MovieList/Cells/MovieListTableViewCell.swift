//
//  MovieListTableViewCell.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 20/08/23.
//

import UIKit
import AlamofireImage

class MovieListTableViewCell: UITableViewCell {
    
    static let reusableIdentifier = String(describing: MovieListTableViewCell.self)
    
    // MARK: - Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var data: MovieModel! {
        didSet {
            titleLabel.text = data.title
            averageLabel.text = String(format: "%.1f", data.voteAverage ?? 0.0)
            dateLabel.text = data.releaseDate
            overviewLabel.text = data.overview
            posterImageView.af.setImage(withURL: getUrl(data.posterPath ?? ""))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
