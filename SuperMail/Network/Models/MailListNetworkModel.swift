//
//  MailListNetworkModel.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 31.10.2021.
//

import Foundation

struct MailListNetworkModel: Decodable {
    let mails: [MailListElementNetworkModel]
    
    enum CodingKeys: String, CodingKey {
        case messages
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mails = try container.decode([MailListElementNetworkModel].self, forKey: .messages)
    }
}


struct MailListElementNetworkModel: Decodable {
    let id: String
    let date: Date
    let fromAdress: String
    let subject: String
    let snippet: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case from
        case subject
        case snippet
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        fromAdress = try container.decode(String.self, forKey: .from)
        subject = try container.decode(String.self, forKey: .subject)
        snippet = try container.decode(String.self, forKey: .snippet)
    }
}
