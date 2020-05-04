//
//  OIDServiceConfiguration.swift
//  AuthenticationKit
//
//  Created by Adam Young on 23/09/2019.
//

import Foundation

public struct OIDServiceConfiguration {

  /// The authorization endpoint URI.
  public let authorizationEndpoint: URL
  /// The token exchange and refresh endpoint URI.
  public let tokenEndpoint: URL
  /// The OpenID Connect issuer.
  public let issuer: URL?
  /// The end session logout endpoint URI.
  public let endSessionEndpoint: URL?

}

extension OIDServiceConfiguration: Codable { }
