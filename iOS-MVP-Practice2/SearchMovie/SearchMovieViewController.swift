//
//  ViewController.swift
//  iOS-MVP-Practice2
//
//  Created by 坂本龍哉 on 2021/04/23.
//

import UIKit

class SearchMovieViewController: UIViewController {
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var resultTableView: UITableView!

    private var presenter: SearchMoviePresenterInput!
    
    func inject(presenter: SearchMoviePresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        movieSearchBar.delegate = self
        resultTableView.dataSource = self
        resultTableView.delegate = self
        movieSearchBar.keyboardType = .namePhonePad
    }

    
    private func setup() {
        resultTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
    }
}


extension SearchMovieViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.didTapSearchButton(text: searchBar.text)
        searchBar.resignFirstResponder()
    }
}

extension SearchMovieViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

extension SearchMovieViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfMovies
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultTableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier, for: indexPath) as! MovieTableViewCell
        cell.resetCell()
        
        let movie = presenter.movie()
        cell.configure(movie: movie[indexPath.row])
        
        return cell
    }
}

extension SearchMovieViewController : SearchMoviePresenterOutput {
    func update(_ movie: [SearchContents]) {
        print(movie)
        resultTableView.reloadData()
    }
}

