//
//  MailDetailRequest.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 01.11.2021.
//

import Foundation

struct MailDetailRequest {
    let service: MailService
    let userInfo: User
    let mailID: String
}

extension MailDetailRequest: Request {
    var requestURL: URL? {
        let queryParametersForMailDetailRequest = [
            URLQueryItem(name: "UserId", value: userInfo.userID),
            URLQueryItem(name: "Token", value: userInfo.userToken),
            URLQueryItem(name: "MailID", value: mailID)
        ]
        var components = URLComponents(string: path)
        components?.queryItems = queryParametersForMailDetailRequest
        return components?.url
    }
    
    var path: String {
        service.serviceURL.absoluteString + "/details"
    }
}
