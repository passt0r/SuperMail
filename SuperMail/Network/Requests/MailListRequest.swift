//
//  MailListRequest.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 01.11.2021.
//

import Foundation

struct MailListRequest: Request, UserIdentifiable {
    let service: MailService
    let userInfo: User
    
    var queryItems: [URLQueryItem]? {
        nil
    }
    
    var path: String {
        "/list"
    }
}
