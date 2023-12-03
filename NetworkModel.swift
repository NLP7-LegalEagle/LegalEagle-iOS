//
//  Network.swift
//  LegalEagle
//
//  Created by 이전희 on 12/3/23.
//

import Foundation
import Alamofire
import Combine

class NetworkModel {
    private var domain: URL = URL(string: "http://127.0.0.1:5000")!
    static let shared: NetworkModel = NetworkModel()
    private init() { }
}

extension NetworkModel {
    func sendText(text: String) -> AnyPublisher<TextGenerationOutput, Error> {
        Future<TextGenerationOutput, Error> { promise in
            let urlRequest = self.urlRequest(httpMethod: "POST",
                                        paths: ["test"],
                                        httpBody: ["input_text":text])
            AF.request(urlRequest)
                .responseDecodable(of: TextGenerationOutput.self) { response in
                    if let value = response.value {
                        promise(.success(value))
                    }
                    
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func urlRequest(httpMethod: String, 
                            paths: [String]? = nil,
                            httpBody: [String: String]? = nil) -> URLRequest {
        var urlRequest = URLRequest(url: self.domain)
        urlRequest.httpMethod = httpMethod
        urlRequest.setValue("application/json",
                            forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json",
                            forHTTPHeaderField: "Content-Type")
        
        if let httpBody = httpBody {
            let httpBodyData = try? JSONSerialization.data(withJSONObject: httpBody)
            urlRequest.httpBody = httpBodyData
        }
        if let paths = paths {
            urlRequest.url?.append(path: paths.joined(separator: "/"))
        }
        
        urlRequest.timeoutInterval = 10
        return urlRequest
    }
}
