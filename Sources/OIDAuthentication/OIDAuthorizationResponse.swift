//
//  File.swift
//  
//
//  Created by Adam Young on 24/09/2019.
//

import Foundation

struct OIDAuthorizationResponse {

  let request: OIDAuthorizationRequest
  let parameters: [String: String]

  init(request: OIDAuthorizationRequest, callbackURL: URL) {
    self.request = request

    let urlComponents = URLComponents(url: callbackURL, resolvingAgainstBaseURL: true)
    self.parameters = urlComponents?.queryItems?.reduce([String: String]()) { parameters, queryItem in
      var parameters = parameters
      parameters[queryItem.name] = queryItem.value
      return parameters
      } ?? [:]
  }

  func tokenExchangeRequest(withAdditionalParameters additionalParameters: [String: String]? = nil)
    -> OIDTokenRequest? {
    guard let authorizationCode = parameters["code"] else {
      return nil
    }

    return OIDTokenRequest(serviceConfiguration: request.serviceConfiguration, grantType: .authorizationCode,
                           authorizationCode: authorizationCode, redirectURL: request.redirectURL,
                           clientID: request.clientID, refreshToken: nil, codeVerifier: request.codeVerifier,
                           additionalParameters: additionalParameters)
  }

}
