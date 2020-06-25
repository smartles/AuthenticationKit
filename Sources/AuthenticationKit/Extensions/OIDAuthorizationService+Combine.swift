//
//  OIDAuthorizationService+Combine.swift
//  AuthenticationKit
//
//  Created by Adam Young on 25/06/2020.
//

import AppAuth
import Combine
import Foundation

extension OIDAuthorizationService {

    static func discoverConfigurationPublisher(forDiscoveryURL discoveryURL: URL) -> AnyPublisher<OIDServiceConfiguration?, Error> {
        Future<OIDServiceConfiguration?, Error> { promise in
            OIDAuthorizationService.discoverConfiguration(forDiscoveryURL: discoveryURL) { configuration, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }

                promise(.success(configuration))
            }
        }
        .eraseToAnyPublisher()
    }

}
