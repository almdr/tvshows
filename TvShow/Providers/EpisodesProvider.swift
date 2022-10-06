//
//  EpisodesProvider.swift
//  TvShow
//
//  Created by Alfonso Muñoz del Río (Contractor) on 5/10/22.
//

import Foundation

public class EpisodesProvider {
    
    public func loadEpisodes(showId: Int,
                            handler: @escaping (Result<[Episodes], Error>) -> Void) {
        guard let baseURL = URL(string: "https://api.tvmaze.com/shows/\(showId)/episodes") else { return }
        var urlRequest = URLRequest(url: baseURL)
        urlRequest.httpMethod = "GET"
        load(urlRequest: urlRequest, then: handler)
    }

    private func load(urlRequest: URLRequest,
              then handler: @escaping (Result<[Episodes], Error>) -> Void) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let httpResponse = response as? HTTPURLResponse, !(200..<300 ~= httpResponse.statusCode) {
                DispatchQueue.main.async {
                    handler(.failure(ShowError.httpError))
                }
                return
            }
            if let error = error {
                self.complete(withError: error, handler: handler)
                return
            }
            guard let data = data else {
                self.complete(withError: ShowError.otherError, handler: handler)
                return
            }
            do {
                let loadedType = try self.decode(data, for: response)
                DispatchQueue.main.async {
                    handler(.success(loadedType))
                }
            } catch {
                self.complete(withError: ShowError.decodingError, handler: handler)
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    private func complete(withError error: Error, handler: @escaping  (Result<[Episodes], Error>) -> Void) {
        DispatchQueue.main.async {
            // Connection failed
            if (error as NSError).code == -1009 {
                handler(.failure(ShowError.connectionError))
            } else {
                handler(.failure(error))
            }
        }
    }
    
    private  func decode(_ data: Data, for response: URLResponse?) throws -> [Episodes] {
        let decored = JSONDecoder()
        decored.keyDecodingStrategy = .convertFromSnakeCase
        return try decored.decode([Episodes].self, from: data)
    }
}
