//
//  MailServices.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 01.11.2021.
//

import Foundation

enum MailService {
    case test
    
    var serviceURL: URL {
        switch self {
        case .test:
            return .init(string: "https://test.testapis.com")!
        }
    }
}
