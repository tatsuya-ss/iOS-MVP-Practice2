//
//  SearchMovieModel.swift
//  iOS-MVP-Practice2
//
//  Created by 坂本龍哉 on 2021/04/23.
//

import Foundation
import Keys

protocol SearchMovieModelInput {
    func fetchMovie(query: String, completion: @escaping (Result<[SearchContents], SearchError>) -> Void)
    
}

final class SearchMovieModel : SearchMovieModelInput {
    func fetchMovie(query: String, completion: @escaping (Result<[SearchContents], SearchError>) -> Void) {
        let key = IOSMVPPractice2Keys().tMDBAPIKey
        let url = "https://api.themoviedb.org/3/search/multi?api_key=\(key)&language=ja-JP&page=1&query=\(query)"

        guard let encoderUrlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let encodeUrl = URL(string: encoderUrlString) else { return }
        let urlRequest = URLRequest(url: encodeUrl,
                                    cachePolicy: .useProtocolCachePolicy,
                                    timeoutInterval: 10)
        
        let task = URLSession.shared.dataTask(with: urlRequest,
                                              completionHandler: { (data, reponse, error) in
                                                do {
                                                    if let error = error {
                                                        completion(.failure(SearchError.requestError(error)))
                                                        return
                                                    }
                                                    
                                                    guard let data = data,
                                                          let response = reponse as? HTTPURLResponse else {
                                                        completion(.failure(SearchError.responseError))
                                                        print("data or response is nil")
                                                        return
                                                    }
                                                    if response.statusCode == 200 {
                                                        let decoder = JSONDecoder()
                                                        let data: SearchResponses = try decoder.decode(SearchResponses.self, from: data)
                                                        completion(.success(data.results))
                                                    }
                                                } catch {
                                                    print(error)
                                                }
                                              }
        )
        task.resume()
    }
}
