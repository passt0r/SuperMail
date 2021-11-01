//
//  MailModel.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 19.10.2021.
//

import Foundation

class MailModel {
    private let mailStorage: MailPersistenceStorageProtocol
    private let networkService: MailNetworkProtocol
    private let userManager: UserManager
    
    init(mailStorage: MailPersistenceStorageProtocol,
         networkService: MailNetworkProtocol,
         userManager: UserManager) {
        self.mailStorage = mailStorage
        self.networkService = networkService
        self.userManager = userManager
    }
    
    private var emailList: [String] = []
    
    func getEmailList() -> [String] {
        return emailList
    }
    
    func getEmailDetail() -> Data {
        return .init()
    }
}
