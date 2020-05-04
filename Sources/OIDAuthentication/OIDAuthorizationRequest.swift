//
//  OIDAuthorizationRequest.swift
//  AuthenticationKit
//
//  Created by Adam Young on 23/09/2019.
//

import CryptoKit
import Foundation

struct OIDAuthorizationRequest {

  private static let stateSizeBytes: UInt = 32
  private static let codeVerifierBytes: UInt = 32
  private static let codeChallengeMethod = "S256"

  let serviceConfiguration: OIDServiceConfiguration
  let clientID: String
  let scopes: Set<String>?
  let redirectURL: URL
  let responseType: OIDResponseType
  let additionalParameters: [String: String]?
  let codeVerifier: String?
  let codeChallenge: String?
  let codeChallengeMethod: String? = "S256"
  let state: String?
  let nonce: String?

  var callbackURLScheme: String? {
    redirectURL.scheme
  }

  init(serviceConfiguration: OIDServiceConfiguration, clientID: String, scopes: Set<String>?, redirectURL: URL,
       responseType: OIDResponseType, additionalParameters: [String : String]? = nil) {
    let codeVerifier = OIDAuthorizationRequest.generateCodeVerifier()
    let codeChallenge = OIDAuthorizationRequest.codeChallengeS256ForVerifier(codeVerifier: codeVerifier)
    let state = OIDAuthorizationRequest.generateState()
    let nonce = OIDAuthorizationRequest.generateState()
    let codeChallengeMethod = OIDAuthorizationRequest.codeChallengeMethod

    self.init(serviceConfiguration: serviceConfiguration, clientID: clientID, scopes: scopes, redirectURL: redirectURL,
              responseType: responseType, additionalParameters: additionalParameters, codeVerifier: codeVerifier,
              codeChallenge: codeChallenge, codeChallengeMethod: codeChallengeMethod, state: state, nonce: nonce)
  }

  init(serviceConfiguration: OIDServiceConfiguration, clientID: String, scopes: Set<String>?, redirectURL: URL,
       responseType: OIDResponseType, additionalParameters: [String : String]? = nil, codeVerifier: String?,
       codeChallenge: String?, codeChallengeMethod: String?, state: String?, nonce: String?) {
    switch responseType {
    case .code, .codeIDToken:
      break

    default:
      assert(false, "Invalid Response Type for Authorization Request")
    }

    self.serviceConfiguration = serviceConfiguration
    self.clientID = clientID
    self.scopes = scopes
    self.redirectURL = redirectURL
    self.responseType = responseType
    self.additionalParameters = additionalParameters
    self.codeVerifier = codeVerifier
    self.codeChallenge = codeChallenge
    self.state = state
    self.nonce = nonce
  }

}

extension OIDAuthorizationRequest {

  func authorizationRequestURL() -> URL {
    var queryItems = [URLQueryItem]()

    queryItems.append(URLQueryItem(name: "response_type", value: responseType.rawValue))
    queryItems.append(URLQueryItem(name: "client_id", value: clientID))
    queryItems.append(URLQueryItem(name: "redirect_uri", value: redirectURL.absoluteString))

    if let scopes = scopes?.joined(separator: " ") {
      queryItems.append(URLQueryItem(name: "scope", value: scopes))
    }

    if let state = state {
      queryItems.append(URLQueryItem(name: "state", value: state))
    }

    if let nonce = nonce {
      queryItems.append(URLQueryItem(name: "nonce", value: nonce))
    }

    if let codeChallenge = codeChallenge {
      queryItems.append(URLQueryItem(name: "code_challenge", value: codeChallenge))
    }

    if let codeChallengeMethod = codeChallengeMethod {
      queryItems.append(URLQueryItem(name: "code_challenge_method", value: codeChallengeMethod))
    }

    if let additionalParameters = additionalParameters {
      for (key, value) in additionalParameters {
        queryItems.append(URLQueryItem(name: key, value: value))
      }
    }

    var urlComponents = URLComponents(url: serviceConfiguration.authorizationEndpoint, resolvingAgainstBaseURL: true)
    urlComponents?.queryItems = queryItems

    guard let url = urlComponents?.url else {
      return serviceConfiguration.authorizationEndpoint
    }

    return url
  }

}

extension OIDAuthorizationRequest {

  private static func generateCodeVerifier() -> String? {
    guard let data = try? Data(randomOfLength: OIDAuthorizationRequest.codeVerifierBytes) else {
      return nil
    }

    return data.base64EncodedStringNoPadding()
  }

  private static func generateState() -> String? {
    guard let data = try? Data(randomOfLength: OIDAuthorizationRequest.stateSizeBytes) else {
      return nil
    }

    return data.base64EncodedStringNoPadding()
  }

  private static func codeChallengeS256ForVerifier(codeVerifier: String?) -> String? {
    guard let codeVerifier = codeVerifier, let data = codeVerifier.data(using: .utf8) else {
      return nil
    }


    let hash = SHA256.hash(data: data)
    return hash.data.base64EncodedStringNoPadding()
  }

}
