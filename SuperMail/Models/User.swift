//
//  User.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 01.11.2021.
//

import Foundation

class UserManager {
    func getUserInfo() -> User {
        // Just mocked data, even not saved to device
        return .init(userID: "TestUser", userToken: "TestToken007")
    }
}

struct User {
    let userID: String
    let userToken: String
}
