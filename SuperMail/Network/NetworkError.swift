//
//  NetworkError.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 04.11.2021.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case network, request, decode
    
    public var errorDescription: String? {
        switch self {
        case .network:
            return "Unkown sending request error"
        case .request:
            return "Error while sending request"
        case .decode:
            return "Error while decode server data"
        }
    }
}
