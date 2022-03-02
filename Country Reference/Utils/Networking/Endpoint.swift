//
//  Endpoint.swift
//  Country Reference
//
//  Created by Kenan Alizadeh on 02.03.22.
//

import Foundation

protocol Endpoint {
    var baseURL: URL { get }

    var path: String { get }

    func makeRequest() -> URLRequest
}

extension Endpoint {
    var baseURL: URL { URL(string: "https://restcountries.com")! }

    func makeRequest() -> URLRequest {
        let url = baseURL.appendingPathComponent(path)

        return URLRequest(url: url)
    }
}
