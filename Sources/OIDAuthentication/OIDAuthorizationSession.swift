//
//  OIDAuthorizationSession.swift
//  OIDAuthentication
//
//  Created by Adam Young on 23/09/2019.
//

import Foundation

final class OIDAuthorizationSession {

  let discoveryURL: URL
  let clientID: String
  let scopes: Set<String>?
  let redirectURL: URL
  let additionalParameters: [String: String]?
  private(set) var serviceConfiguration: OIDServiceConfiguration?
  private(set) var lastAuthorizationRequest: OIDAuthorizationRequest?
  private(set) var lastAuthorizationResponse: OIDAuthorizationResponse?
  private(set) var lastTokenRequest: OIDTokenRequest?
  private(set) var lastTokenResponse: OIDTokenResponse?

  init(discoveryURL: URL, clientID: String, scopes: Set<String>? = nil, redirectURL: URL,
       additionalParameters: [String: String]? = nil) {
    self.discoveryURL = discoveryURL
    self.clientID = clientID
    self.scopes = scopes
    self.redirectURL = redirectURL
    self.additionalParameters = additionalParameters
  }

  func update(with serviceConfiguration: OIDServiceConfiguration) {
    self.serviceConfiguration = serviceConfiguration
  }

  func update(with authorizationRequest: OIDAuthorizationRequest) {
    self.lastAuthorizationRequest = authorizationRequest
  }

  func update(with authorizationResponse: OIDAuthorizationResponse) {
    self.lastAuthorizationResponse = authorizationResponse
  }

  func update(with tokenRequest: OIDTokenRequest) {
    self.lastTokenRequest = tokenRequest
  }

  func update(with tokenResponse: OIDTokenResponse) {
    self.lastTokenResponse = tokenResponse
  }
  

}
