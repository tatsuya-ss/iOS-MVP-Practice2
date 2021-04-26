//
//  SearchMoviePresenter.swift
//  iOS-MVP-Practice2
//
//  Created by 坂本龍哉 on 2021/04/23.
//

import Foundation

protocol SearchMoviePresenterInput {
    func didTapSearchButton(text: String?)
    var numberOfMovies: Int { get }
    func movie() -> [SearchContents]
}

protocol SearchMoviePresenterOutput : AnyObject {
    func update(_ movie: [SearchContents])
}

final class SearchMoviePresenter : SearchMoviePresenterInput {
    
    
    private weak var view: SearchMoviePresenterOutput!
    private var model: SearchMovieModelInput
    
    private(set) var movies: [SearchContents] = []
    
    init(view: SearchMoviePresenterOutput, model: SearchMovieModelInput) {
        self.view = view
        self.model = model
    }
    
    var numberOfMovies: Int {
        movies.count
    }

    func movie() -> [SearchContents] {
        movies
    }
    
    func didTapSearchButton(text: String?) {
        guard let query = text else { return }
        guard !query.isEmpty else { return }
        
        model.fetchMovie(query: query, completion: { [weak self] result in
            switch result {
            case let .success(contents):
                self?.movies = contents
                DispatchQueue.main.async {
                    self?.view.update(contents)
                }
            case let .failure(SearchError.requestError(error)):
                print(error)
            case let .failure(error):
                print(error)
            }
        })
    }
}

struct SearchResponses : Codable {
    var results: [SearchContents]
}

struct SearchContents : Codable {
    var title: String?
    var poster_path: String?
    var original_name: String?
}

enum SearchError : Error {
    case requestError(Error)
    case responseError
}
