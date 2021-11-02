//
//  MailURLProtocol.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 19.10.2021.
//

import Foundation
import Dispatch

class MailURLProtocol: URLProtocol {
    private static var mockResponses: [URL : Result<Data, Error>] = [:]
    static var mocks: (()->[URL : Result<Data, Error>])?
    
    override class func canInit(with request: URLRequest) -> Bool {
        let mockService = MailService.test.serviceURL.absoluteString
        return request.url?.absoluteString.contains(mockService) ?? false
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func stopLoading() {}
    
    override func startLoading() {
        // Simulate background responce
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else {
                assertionFailure("No mock URL protocol")
                return
            }
            self.loadMocks()
            guard let requestUrl = self.request.url else {
                assertionFailure("No url for request: \(self.request)")
                return
            }
            var components = URLComponents(url: requestUrl, resolvingAgainstBaseURL: false)
            components?.queryItems = nil
            guard let url = components?.url,
                  let responce = MailURLProtocol.mockResponses[url] else {
                assertionFailure("No mock responce for url: \(requestUrl)")
                return
            }
            switch responce {
            case .success(let result):
                let urlResponse = URLResponse(
                    url: requestUrl,
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

private extension MailURLProtocol {
    func loadMocks() {
        guard let mocks = MailURLProtocol.mocks,
              MailURLProtocol.mockResponses.isEmpty else {
            return
        }
        MailURLProtocol.mockResponses = mocks()
    }
}
