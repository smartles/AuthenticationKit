//
//  OIDAuthState.swift
//  AuthenticationKit
//
//  Created by Adam Young on 25/06/2020.
//

import AppAuth
import Combine
import Foundation

extension OIDAuthState {
    func performActionPublisher() -> AnyPublisher<(String?, String?), Error> {
        Future<(String?, String?), Error> { promise in
            self.performAction { accessToken, idToken, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }

                promise(.success((accessToken, idToken)))
            }
        }
        .eraseToAnyPublisher()
    }
}
