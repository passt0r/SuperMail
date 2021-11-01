//
//  MailNetworkService.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 19.10.2021.
//

import Foundation

typealias MailListRequestResult = Result<MailListNetworkModel, Error>
typealias MailDetailRequestResult = Result<MailContentNetworkModel, Error>

protocol NetworkSessionProtocol {
    func loadData(from url: URL,
                  completion: @escaping (Data?, Error?) -> Void)
}

protocol MailNetworkProtocol {
    func loadMailList(from service: MailService,
                      with userInfo: User,
                      completion: @escaping (MailListRequestResult) -> Void)
    func loadMailDetail(from service: MailService,
                        with userInfo: User,
                        mailID: String,
                        completion: @escaping (MailDetailRequestResult) -> Void)
}

extension URLSession: NetworkSessionProtocol {
    func loadData(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let task = dataTask(with: url) { data, _, error in
            completion(data, error)
        }
        task.resume()
    }
}

class MailNetworkService: MailNetworkProtocol {
    private let session: NetworkSessionProtocol

    init(session: NetworkSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func loadMailList(from service: MailService,
                      with userInfo: User,
                      completion: @escaping (MailListRequestResult) -> Void) {
        let mailListRequest = MailListRequest(service: service,
                                              userInfo: userInfo)
        loadMailData(with: mailListRequest,
                     completion: completion)
        
    }
    
    func loadMailDetail(from service: MailService,
                        with userInfo: User,
                        mailID: String,
                        completion: @escaping (MailDetailRequestResult) -> Void) {
        let mailDetailRequest = MailDetailRequest(service: service,
                                                  userInfo: userInfo,
                                                  mailID: mailID)
        loadMailData(with: mailDetailRequest,
                     completion: completion)
    }
}

private extension MailNetworkService {
    func loadMailData<MailData: Decodable>(with request: Request,
                                           completion: @escaping (Result<MailData, Error>) -> Void) {
        guard let requestURL = request.requestURL else {
            let error = NSError(domain: "Request", code: 0)
            DispatchQueue.main.async {
                completion(.failure(error))
            }
            return
        }
        session.loadData(from: requestURL) { data, error in
            guard let resultData = data else {
                let error = error ?? NSError(domain: "Network", code: 0)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            guard let mailData = try? decoder.decode(MailData.self, from: resultData) else {
                let error = error ?? NSError(domain: "Decode", code: 0)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(mailData))
            }
        }
        
    }
}
