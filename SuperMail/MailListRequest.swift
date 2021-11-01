//
//  MailListRequest.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 01.11.2021.
//

import Foundation

struct MailListRequest {
    let service: MailService
    let userInfo: User
}

extension MailListRequest: Request {
    var requestURL: URL? {
        let queryParametersForListRequest = [
            URLQueryItem(name: "UserId", value: userInfo.userID),
            URLQueryItem(name: "Token", value: userInfo.userToken)
        ]
        var components = URLComponents(url: service.serviceURL,
                                       resolvingAgainstBaseURL: true)
        components?.queryItems = queryParametersForListRequest
        return components?.url
    }
}
