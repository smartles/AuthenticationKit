//
//  OIDGrantType.swift
//  OIDAuthentication
//
//  Created by Adam Young on 24/09/2019.
//

import Foundation

public enum OIDGrantType: String {

  case authorizationCode = "authorization_code"
  case refreshToken = "refresh_token"
  case password = "password"
  case clientCredentials = "client_credentials"

}
