//
//  OIDProviderConfiguration.swift
//  AuthenticationKit
//
//  Created by Adam Young on 25/06/2020.
//

import Foundation

public struct OIDProviderConfiguration {
  public let wellKnownEndpoint: URL
  public let clientID: String
  public let additionalScopes: Set<String>
  public let additionalParameters: [String: String]

  public init(wellKnownEndpoint: URL, clientID: String, additionalScopes: Set<String> = [],
              additionalParameters: [String: String] = [:]) {
    self.wellKnownEndpoint = wellKnownEndpoint
    self.clientID = clientID
    self.additionalScopes = additionalScopes
    self.additionalParameters = additionalParameters
  }
}

extension OIDProviderConfiguration: Equatable { }

public protocol OIDProviderConfigurationRepresentable {
  func oidProviderConfigurationValue() -> OIDProviderConfiguration
}

extension OIDProviderConfiguration: OIDProviderConfigurationRepresentable {
  public func oidProviderConfigurationValue() -> OIDProviderConfiguration {
    self
  }
}
