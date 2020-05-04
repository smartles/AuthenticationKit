//
//  OIDTokenResponse.swift
//  OIDAuthentication
//
//  Created by Adam Young on 24/09/2019.
//

import Foundation

struct OIDTokenResponse {

  let tokenType: String
  let idToken: String
  let accessToken: String
  let refreshToken: String
  
}

extension OIDTokenResponse: Decodable { }
