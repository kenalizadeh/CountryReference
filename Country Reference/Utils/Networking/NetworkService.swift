//
//  NetworkService.swift
//  Country Reference
//
//  Created by Kenan Alizadeh on 01.03.22.
//

import Foundation
import Combine

class NetworkService<T: Decodable> {
    @Published
    private(set) var responseDTO: T?

    @Published
    private(set) var error: Error?

    private let queue: DispatchQueue = DispatchQueue(label: "NetworkServiceQueue", qos: .utility, attributes: .concurrent)

    private var cancellable: AnyCancellable?

    private func publisher(for request: URLRequest) -> AnyPublisher<T, Error> {
        URLSession
            .shared
            .dataTaskPublisher(for: request)
            .map(\.data)
            .subscribe(on: queue)
            .receive(on: DispatchQueue.main)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func execute(for endpoint: Endpoint) {
        let request = endpoint.makeRequest()

        let publisher = publisher(for: request)

        cancellable?.cancel()
        cancellable = publisher
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.error = error
                    self.responseDTO = nil
                    print(":LOG: - \(Self.self) | Endpoint: \(endpoint) | Error: \(error)")
                }
            }, receiveValue: { value in
                self.responseDTO = value
                print(":LOG: - \(Self.self) | Endpoint: \(endpoint) | Success")
            })
    }
}
