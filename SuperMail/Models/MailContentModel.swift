//
//  MailContentModel.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 02.11.2021.
//

import Foundation

struct MailContentModel {
    var mailId: String
    let content: Data
}

extension MailContentModel {
    mutating func setNewMailId(newId: String) {
        mailId = newId
    }
}
