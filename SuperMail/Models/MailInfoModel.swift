//
//  MailInfoModel.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 02.11.2021.
//

import Foundation

struct MailInfoModel {
    let mailId: String
    let date: Date
    let fromAdress: String
    let subject: String
    let snippet: String
    
    var mailContent: MailContentModel?
}

extension MailInfoModel {
    mutating func setNewMailContent(newContent: MailContentModel?) {
        mailContent = newContent
    }
}
