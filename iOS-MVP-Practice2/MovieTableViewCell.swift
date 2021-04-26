//
//  MovieTableViewCell.swift
//  iOS-MVP-Practice2
//
//  Created by 坂本龍哉 on 2021/04/23.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let reuseIdentifier = "MovieCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView?.image = nil
        titleLabel.text = nil
    }
    
    func resetCell() {
        movieImageView.image = nil
        titleLabel.text = nil
    }
    
    func configure(movie: SearchContents) {
        guard let posterPath = movie.poster_path,
              let url = URL(string: "https://image.tmdb.org/t/p/w185\(posterPath)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let imageData = data else { return }
            
            DispatchQueue.global().async { [weak self] in
                guard let image = UIImage(data: imageData) else { return }
                
                DispatchQueue.main.async {
                    self?.movieImageView.image = image
                }
            }
            
        }
        task.resume()
        if movie.title == nil {
            titleLabel.text = movie.original_name
        } else {
            titleLabel.text = movie.title
        }
    }
}
