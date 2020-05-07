//
//  UserCredential.swift
//  AuthenticationKit
//
//  Created by Adam Young on 23/09/2019.
//

import Combine
import Foundation

public final class UserCredential: Codable, Equatable {

  private let serviceConfiguration: OIDServiceConfiguration
  private var lastTokenReponse: OIDTokenResponse

  public var idToken: String {
    lastTokenReponse.idToken
  }

  public var accessToken: String {
    lastTokenReponse.accessToken
  }

  init(serviceConfiguration: OIDServiceConfiguration, tokenResponse: OIDTokenResponse) {
    self.serviceConfiguration = serviceConfiguration
    self.lastTokenReponse = tokenResponse
  }

  public static func == (lhs: UserCredential, rhs: UserCredential) -> Bool {
    lhs.lastTokenReponse == rhs.lastTokenReponse
      && lhs.serviceConfiguration == rhs.serviceConfiguration
  }

  public func acquireToken() -> AnyPublisher<String, OIDAuthorizationError> {
    Just(accessToken)
      .setFailureType(to: OIDAuthorizationError.self)
      .eraseToAnyPublisher()
  }

//  public convenience init?(coder: NSCoder) {
//    let jsonDecoder = JSONDecoder()
//    guard
//      let serviceConfigurationData = coder.decodeObject(forKey: CoderKeys.serviceConfiguration) as? Data,
//      let serviceConfiguration = try? jsonDecoder.decode(OIDServiceConfiguration.self, from: serviceConfigurationData)
//      else {
//        return nil
//    }
//
//    self.init(serviceConfiguration: serviceConfiguration)
//  }
//
//  public func encode(with coder: NSCoder) {
//    let jsonEncoder = JSONEncoder()
//    coder.encode(try? jsonEncoder.encode(serviceConfiguration), forKey: CoderKeys.serviceConfiguration)
//   }

}
