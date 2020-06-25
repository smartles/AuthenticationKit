//
//  AuthenticationService.swift
//  AuthenticationKit
//
//  Created by Adam Young on 25/06/2020.
//

import AppAuth
import Combine
import Foundation

public final class AuthenticationService {
    private static var currentAuthorizationFlow: OIDExternalUserAgentSession?

    public init() { }

    public func signIn(configuration: OIDProviderConfigurationRepresentable, redirectURL: URL,
                loginHint: String? = nil) -> AnyPublisher<AuthState, Error> {
        let providerConfiguration = configuration.oidProviderConfigurationValue()
        return OIDAuthorizationService.discoverConfigurationPublisher(forDiscoveryURL: providerConfiguration.wellKnownEndpoint)
            .tryMap { serviceConfiguration -> OIDAuthorizationRequest in
                guard let serviceConfiguration = serviceConfiguration else {
                    throw AuthenticationError.noServiceConfiguration
                }

                return OIDAuthorizationRequest(configuration: serviceConfiguration,
                                               providerConfiguration: providerConfiguration, loginHint: loginHint,
                                               redirectURL: redirectURL)
            }
            .flatMap { Self.authStatePublisher(byPresenting: $0) }
            .tryMap { authState -> AuthState in
                guard let authState = authState else {
                    throw AuthenticationError.noAuthState
                }

                return AuthState(state: authState)
            }
            .eraseToAnyPublisher()
    }

}

extension AuthenticationService {
    private static func authStatePublisher(byPresenting request: OIDAuthorizationRequest) -> AnyPublisher<OIDAuthState?, Error> {
        Future<OIDAuthState?, Error> { promise in
            let rootViewController = UIApplication.shared.windows.first!.rootViewController!
            Self.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: rootViewController) { authState, error in
                if let error = error {
                    promise(.failure(error))
                    Self.currentAuthorizationFlow = nil
                    return
                }

                promise(.success(authState))
                Self.currentAuthorizationFlow = nil
            }
        }
        .eraseToAnyPublisher()
    }
}
