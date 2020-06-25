//
//  AuthState.swift
//  AuthenticationKit
//
//  Created by Adam Young on 25/06/2020.
//

import AppAuth
import Combine
import Foundation

public final class AuthState {
    private let authState: OIDAuthState

    public private(set) var jwt: JWT?

    public var lastIDToken: String? {
        authState.lastTokenResponse?.idToken
    }

    public var lastAccessToken: String? {
        authState.lastTokenResponse?.accessToken
    }

    init(state: OIDAuthState) {
        self.authState = state
        self.jwt = JWT(fromAccessToken: authState.lastTokenResponse?.accessToken,
                       or: authState.lastTokenResponse?.idToken)
    }

    public func performAction() -> AnyPublisher<String?, Error> {
        authState.performActionPublisher()
            .map { JWT(fromAccessToken: $0.0, or: $0.1) }
            .handleEvents(receiveOutput: { self.jwt = $0 })
            .map { $0?.rawValue }
            .mapError { AuthenticationError.cannotRefreshToken(error: $0) }
            .eraseToAnyPublisher()
    }
}

extension AuthState: Codable {
    private enum CodingKeys: String, CodingKey {
        case authState
    }

    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let stateData = try container.decode(Data.self, forKey: .authState)
        let state = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(stateData) as! OIDAuthState

        self.init(state: state)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        let stateData = try NSKeyedArchiver.archivedData(withRootObject: authState, requiringSecureCoding: true)
        try container.encode(stateData, forKey: .authState)
    }
}
