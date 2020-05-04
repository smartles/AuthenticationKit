//
//  OIDAuthorizationServiceProtocol.swift
//  AuthenticationKit
//
//  Created by Adam Young on 23/09/2019.
//

import AuthenticationServices
import Combine
import Foundation
import OIDAuthentication

protocol OIDAuthorizationServiceProtocol {

  @available(iOS 13.0, *)
  func authorize(discoveryURL: URL, clientID: String, scopes: Set<String>, redirectURL: URL,
                 additionalParameters: [String: String],
                 presentationContextProvider: ASWebAuthenticationPresentationContextProviding)
    -> AnyPublisher<UserCredential, OIDAuthorizationError>

}

extension OIDAuthorizationService: OIDAuthorizationServiceProtocol { }
