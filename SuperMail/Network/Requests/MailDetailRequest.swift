//
//  MailDetailRequest.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 01.11.2021.
//

import Foundation

struct MailDetailRequest: Request, UserIdentifiable {
    let service: MailService
    let userInfo: User
    let mailID: String
        
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "MailID", value: mailID)]
    }
    
    var path: String {
        "/details"
    }
}
