//
//  MailURLProtocol.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 19.10.2021.
//

import Foundation
import Dispatch

class MailURLProtocol: URLProtocol {
    static var mockResponses: [URL : Result<Data, Error>] = [:]
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func stopLoading() {}
    
    override func startLoading() {
        guard let responce = MailURLProtocol.mockResponses[request.url!] else {
            fatalError("No mock responce for url: \(request.url!)")
        }
        // Simulate background responce
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else {
                return
            }
            switch responce {
            case .success(let result):
                let urlResponse = URLResponse(
                    url: self.request.url!,
                    mimeType: nil,
                    expectedContentLength: result.count,
                    textEncodingName: nil)
                self.client?.urlProtocol(self,
                                    didReceive: urlResponse,
                                    cacheStoragePolicy: .notAllowed)
                self.client?.urlProtocol(self,
                                    didLoad: result)
                self.client?.urlProtocolDidFinishLoading(self)
            case .failure(let error):
                self.client?.urlProtocol(self, didFailWithError: error)
            }
        }
    }
}
