//
//  AuthenticationError.swift
//  AuthenticationKit
//
//  Created by Adam Young on 25/06/2020.
//

enum AuthenticationError: Error {
    case noServiceConfiguration
    case noAuthState
    case cannotRefreshToken(error: Error)
}
