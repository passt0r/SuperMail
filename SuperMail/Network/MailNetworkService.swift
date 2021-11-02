//
//  MailNetworkService.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 19.10.2021.
//

import Foundation
//TODO: should change to in-app models
typealias MailListRequestResult = Result<MailListNetworkModel, Error>
typealias MailDetailRequestResult = Result<MailContentNetworkModel, Error>

protocol MailNetworkProtocol {
    func loadMailList(with userInfo: User,
                      completion: @escaping (MailListRequestResult) -> Void)
    func loadMailDetail(with userInfo: User,
                        mailID: String,
                        completion: @escaping (MailDetailRequestResult) -> Void)
}

class MailNetworkService: MailNetworkProtocol {
    private let session: NetworkSessionProtocol
    private let service = MailService.test

    init(session: NetworkSessionProtocol = NetworkURLSession()) {
        self.session = session
    }
    
    func loadMailList(with userInfo: User,
                      completion: @escaping (MailListRequestResult) -> Void) {
        let mailListRequest = MailListRequest(service: service,
                                              userInfo: userInfo)
        loadMailData(with: mailListRequest,
                     completion: completion)
        
    }
    
    func loadMailDetail(with userInfo: User,
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
    func loadMailData<MailData: Decodable>(with request: UserIdentifiableRequest,
                                           completion: @escaping (Result<MailData, Error>) -> Void) {
        guard let requestURL = request.request else {
            let error = NSError(domain: "Request", code: 0)
            completion(.failure(error))
            return
        }
        session.loadData(from: requestURL) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                guard let mailData = try? decoder.decode(MailData.self, from: data) else {
                    let error = NSError(domain: "Decode", code: 0)
                    completion(.failure(error))
                    return
                }
                completion(.success(mailData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
}
