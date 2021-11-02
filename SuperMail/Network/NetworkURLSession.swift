//
//  NetworkURLSession.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 01.11.2021.
//

import Foundation

typealias SessionResult = Result<Data, Error>

protocol NetworkSessionProtocol {
    func loadData(from urlRequest: URLRequest,
                  completion: @escaping (SessionResult) -> Void)
}

class NetworkURLSession: NetworkSessionProtocol {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func loadData(from urlRequest: URLRequest, completion: @escaping (SessionResult) -> Void) {
        let task = session.dataTask(with: urlRequest) { data, _, error in
            if let data = data {
                completion(.success(data))
            } else if let error = error {
                completion(.failure(error))
            } else {
               let error = NSError(domain: "Network", code: 0)
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
