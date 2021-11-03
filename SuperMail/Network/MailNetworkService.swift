//
//  MailNetworkService.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 19.10.2021.
//

import Foundation

//MARK: - typealiases
typealias MailListRequestResult = Result<[MailInfoModel], Error>
typealias MailDetailRequestResult = Result<MailContentModel, Error>

//MARK: - Protocols
///Classes that implementing this protocol should provide network services for downloading emails alongside with their content.
protocol MailNetworkProtocol {
    ///Uses for downloading list of emails.
    func loadMailList(with userInfo: User,
                      completion: @escaping (MailListRequestResult) -> Void)
    ///Uses for downloading content of the provided email.
    func loadMailDetail(with userInfo: User,
                        for mail: MailInfoModel,
                        completion: @escaping (MailDetailRequestResult) -> Void)
}

//MARK: - Service implementation
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
                     decode: MailListNetworkModel.self) { result in
            let mappedResult = result.map { $0.mails.map(MailInfoModel.init(from:)) }
            completion(mappedResult)
        }
        
    }
    
    func loadMailDetail(with userInfo: User,
                        for mail: MailInfoModel,
                        completion: @escaping (MailDetailRequestResult) -> Void) {
        let mailDetailRequest = MailDetailRequest(service: service,
                                                  userInfo: userInfo,
                                                  mailID: mail.mailId)
        loadMailData(with: mailDetailRequest,
                     decode: MailContentNetworkModel.self) { result in
            completion(result.map(MailContentModel.init(from:)))
        }
    }
}

private extension MailNetworkService {
    func loadMailData<MailData: MailDecodable>(with request: UserIdentifiableRequest,
                                               decode toType: MailData.Type,
                                               completion: @escaping (Result<MailData, Error>) -> Void) {
        guard let requestURL = request.request else {
            completion(.failure(NetworkError.request))
            return
        }
        session.loadData(from: requestURL) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                decoder.dataDecodingStrategy = .base64
                guard let mailData = try? decoder.decode(MailData.self, from: data) else {
                    completion(.failure(NetworkError.decode))
                    return
                }
                completion(.success(mailData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
}
