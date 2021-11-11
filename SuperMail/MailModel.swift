//
//  MailModel.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 19.10.2021.
//

import Foundation

class MailModel {
    private let mailStorage: MailPersistenceStorage
    private let mailProvider: MailProvider
    private let networkService: MailNetwork
    private let userManager: UserManager
    
    init(mailStorage: MailPersistenceStorage,
         mailProvider: MailProvider,
         networkService: MailNetwork,
         userManager: UserManager) {
        self.mailStorage = mailStorage
        self.mailProvider = mailProvider
        self.networkService = networkService
        self.userManager = userManager
    }

    
}

//MARK: - Mail list
extension MailModel {
    var emailsCount: Int {
        mailProvider.mailsCount
    }
    
    subscript(emailIndex: Int) -> MailInfoModel {
        mailProvider[emailIndex]
    }
}

extension MailModel {
    func beginLoading() throws {
        try updateMails()
        try mailProvider.loadData()
    }
    
    func updateMails() throws {
        networkService.loadMailList(with: userManager.getUserInfo()) { [weak self] mailListResult in
            guard let self = self else {
                return
            }
            switch mailListResult {
            case .success(let mailsList):
                self.mailStorage.add(newMails: mailsList)
            case .failure(let error):
                //TODO: throws error outside closure
                break
            }
        }
    }
}

//MARK: - Mail
extension MailModel {
    func getEmailDetail(for mail: MailInfoModel) -> MailContentModel {
        //TODO: implementation (load data if not exist and after - update mail object)
        return .init(mailId: "", content: .init())
    }
    
    func read(mail: MailInfoModel) {
        mailStorage.read(mail: mail)
    }
    
    func delete(mail: MailInfoModel) {
        mailStorage.delete(mail: mail)
    }
}
