//
//  MailContentNetworkModel.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 31.10.2021.
//

import Foundation

struct MailContentNetworkModel: MailDecodable {
    let id: String
    let payload: Data
    
    enum CodingKeys: String, CodingKey {
        case id
        case payload
    }
    
    enum PayloadCodingKeys: String, CodingKey {
        case body
    }
    
    enum PayloadBodyCodingKeys: String, CodingKey {
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        let payloadContainer = try container.nestedContainer(keyedBy: PayloadCodingKeys.self, forKey: .payload)
        let payloadBodyContainer = try payloadContainer.nestedContainer(keyedBy: PayloadBodyCodingKeys.self, forKey: .body)
        payload = try payloadBodyContainer.decode(Data.self, forKey: .data)
    }
}

//MARK: - Parse to domain models
extension MailContentModel {
    init(from model: MailContentNetworkModel) {
        self.mailId = model.id
        self.content = model.payload
    }
}
