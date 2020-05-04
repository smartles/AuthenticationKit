//
//  OIDAuthorizationService.swift
//  AuthenticationKit
//
//  Created by Adam Young on 23/09/2019.
//

import AuthenticationServices
import Combine
import Foundation
import OIDAuthentication

public final class AuthorizationService {
  
  public static let shared = AuthorizationService()
  
  private let oidAuthorizationService: OIDAuthorizationServiceProtocol
  
  public var presentationContextProvider: ASWebAuthenticationPresentationContextProviding?
  
  init(oidAuthorizationService: OIDAuthorizationServiceProtocol = OIDAuthorizationService.shared) {
    self.oidAuthorizationService = oidAuthorizationService
  }
  
}

extension AuthorizationService {
  
  public func authorize(discoveryURL: URL, clientID: String, scopes: Set<String>, redirectURL: URL,
                        additionalParameters: [String: String])
    -> AnyPublisher<UserCredential, OIDAuthorizationError> {
      guard let presentationContextProvider = presentationContextProvider else {
        fatalError()
      }
      
      return oidAuthorizationService.authorize(discoveryURL: discoveryURL, clientID: clientID, scopes: scopes,
                                               redirectURL: redirectURL, additionalParameters: additionalParameters,
                                               presentationContextProvider: presentationContextProvider)
  }
  
}
