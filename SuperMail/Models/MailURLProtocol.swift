//
//  MailURLProtocol.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 19.10.2021.
//

import Foundation
import Dispatch

class MailURLProtocol: URLProtocol {
    static var mockResponses: [URL : (HTTPURLResponse, Data)] = [:]
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func stopLoading() {}
    
    override func startLoading() {
        guard let (response, data) = MailURLProtocol.mockResponses[request.url!] else {
            fatalError("No mock responce for url: \(request.url!)")
        }
        // Simulate background responce
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else {
                return
            }
            do {
                self.client?.urlProtocol(self,
                                    didReceive: response,
                                    cacheStoragePolicy: .notAllowed)
                self.client?.urlProtocol(self,
                                    didLoad: data)
                self.client?.urlProtocolDidFinishLoading(self)
            } catch {
                self.client?.urlProtocol(self, didFailWithError: error)
            }
        }
    }
}
