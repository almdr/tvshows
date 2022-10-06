//
//  SearchProvider.swift
//  TvShow
//
//  Created by Alfonso Muñoz del Río (Contractor) on 5/10/22.
//

import Foundation

public class SearchProvider {
    
    public func loadSearch(query:String,
                            handler: @escaping (Result<[SearchResult], Error>) -> Void) {
        guard let baseURL = URL(string: "https://api.tvmaze.com/search/shows") else { return }
        guard var components = URLComponents(url: baseURL,
                                             resolvingAgainstBaseURL: false) else { fatalError("invalid URL") }
        components.queryItems = [URLQueryItem(name: "q", value: query)]
        guard let url = components.url else { fatalError("invalid URL") }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        load(urlRequest: urlRequest, then: handler)
    }

    private func load(urlRequest: URLRequest,
              then handler: @escaping (Result<[SearchResult], Error>) -> Void) {
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
    
    private func complete(withError error: Error, handler: @escaping  (Result<[SearchResult], Error>) -> Void) {
        DispatchQueue.main.async {
            // Connection failed
            if (error as NSError).code == -1009 {
                handler(.failure(ShowError.connectionError))
            } else {
                handler(.failure(error))
            }
        }
    }
    
    private  func decode(_ data: Data, for response: URLResponse?) throws -> [SearchResult] {
        let decored = JSONDecoder()
        decored.keyDecodingStrategy = .convertFromSnakeCase
        return try decored.decode([SearchResult].self, from: data)
    }
}
