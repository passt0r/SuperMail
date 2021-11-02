//
//  RequestProtocol.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 01.11.2021.
//

import Foundation

typealias UserIdentifiableRequest = Request & UserIdentifiable

protocol UserIdentifiable {
    var userInfo: User { get }
}

protocol Request {
    var service: MailService { get }
    var queryItems: [URLQueryItem]? { get }
    var path: String { get }
}

extension Request {
    var apiAbsoluteURL: String {
        service.serviceURL.absoluteString + path
    }
}

private extension Request {
    var url: URL? {
        guard let queryItems = queryItems else {
            return URLComponents(string: apiAbsoluteURL)?.url
        }
        var components = URLComponents(string: apiAbsoluteURL)
        components?.queryItems = queryItems
        return components?.url
    }
}

extension Request where Self: UserIdentifiable {
    var request: URLRequest? {
        guard let url = url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue(userInfo.userID, forHTTPHeaderField: "UserId")
        request.setValue(userInfo.userToken, forHTTPHeaderField: "Token")
        return request
    }
}
