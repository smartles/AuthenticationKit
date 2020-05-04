//
//  OIDAuthorizationError.swift
//  OIDAuthentication
//
//  Created by Adam Young on 23/09/2019.
//

import Foundation

public enum OIDAuthorizationError: Error {

  case authorizationInProgress
  case network
  case decoding(Error)
  case unableToOpenWebView
  case webAuthenticationSession(Error)
  case webAuthenticationSessionCallbackURL
  case noAuthorizationCode

}
