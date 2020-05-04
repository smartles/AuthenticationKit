//
//  OIDTokenRequest.swift
//  OIDAuthentication
//
//  Created by Adam Young on 24/09/2019.
//

import Foundation

struct OIDTokenRequest {

  let serviceConfiguration: OIDServiceConfiguration
  let grantType: OIDGrantType
  let authorizationCode: String?
  let redirectURL: URL?
  let clientID: String
  let refreshToken: String?
  let codeVerifier: String?
  let additionalParameters: [String: String]?

  init(serviceConfiguration: OIDServiceConfiguration, grantType: OIDGrantType, authorizationCode: String? = nil,
       redirectURL: URL?, clientID: String, refreshToken: String? = nil, codeVerifier: String? = nil,
       additionalParameters: [String: String]? = nil) {
    self.serviceConfiguration = serviceConfiguration
    self.grantType = grantType
    self.authorizationCode = authorizationCode
    self.redirectURL = redirectURL
    self.clientID = clientID
    self.refreshToken = refreshToken
    self.codeVerifier = codeVerifier
    self.additionalParameters = additionalParameters
  }

  func tokenRequestURL() -> URL {
    serviceConfiguration.tokenEndpoint
  }

  func tokenRequestBody() -> [String: String] {
    var body = [String: String]()
    body["grant_type"] = grantType.rawValue
    body["client_id"] = clientID

    if let authorizationCode = authorizationCode {
      body["code"] = authorizationCode
    }

    if let redirectURL = redirectURL {
      body["redirect_uri"] = redirectURL.absoluteString
    }

    if let refreshToken = refreshToken {
      body["refresh_token"] = refreshToken
    }

    if let codeVerifier = codeVerifier {
      body["code_verifier"] = codeVerifier
    }

    if let additionalParameters = additionalParameters {
      additionalParameters.forEach { (key, value) in
        body[key] = value
      }
    }

    return body
  }

  func urlRequest() -> URLRequest {
    var urlRequest = URLRequest(url: tokenRequestURL())
    urlRequest.httpMethod = "POST"
    urlRequest.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")

    var urlParser = URLComponents()
    urlParser.queryItems = tokenRequestBody().map { (key, value) in
      URLQueryItem(name: key, value: value)
    }

    let bodyString = urlParser.percentEncodedQuery
    urlRequest.httpBody = bodyString?.data(using: .utf8)

    return urlRequest
  }

}
