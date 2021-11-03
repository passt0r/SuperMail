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
    
    private var emailList: [MailInfoModel] = []
    
}

//MARK: - Mail list
extension MailModel {
    var emailsCount: Int {
        return emailList.count
    }
    
    subscript(emailIndex: Int) -> MailInfoModel {
        return emailList[emailIndex]
    }
}

//MARK: - Mail detail
extension MailModel {
    func getEmailDetail(for mail: MailInfoModel) -> MailContentModel {
        //TODO: implementation
        return .init(mailId: "", content: .init())
    }
}
