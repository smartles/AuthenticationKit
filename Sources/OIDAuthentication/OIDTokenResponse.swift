//
//  OIDTokenResponse.swift
//  OIDAuthentication
//
//  Created by Adam Young on 24/09/2019.
//

import Foundation

struct OIDTokenResponse: Codable, Equatable {

  let tokenType: String
  let idToken: String
  let accessToken: String
  let refreshToken: String
  
}
