//
//  User.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 01.11.2021.
//

import Foundation

class UserManager {
    private static let mockUser = User(userID: UUID().uuidString,
                                       userToken: UUID().uuidString)
    func getUserInfo() -> User {
        // Just mocked data, even not saved to device
        UserManager.mockUser
    }
}

struct User {
    let userID: String
    let userToken: String
}
