//
//  OIDServiceConfiguration.swift
//  AuthenticationKit
//
//  Created by Adam Young on 23/09/2019.
//

import Foundation

public struct OIDServiceConfiguration: Codable, Equatable {

  public let authorizationEndpoint: URL
  public let tokenEndpoint: URL
  public let issuer: URL?
  public let endSessionEndpoint: URL?

}
