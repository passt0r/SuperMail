//
//  RequestProtocol.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 01.11.2021.
//

import Foundation

protocol Request {
    var path: String { get }
    var requestURL: URL? { get }
}
