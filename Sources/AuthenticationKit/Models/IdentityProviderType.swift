//
//  IdentityProviderType.swift
//  AuthenticationKit
//
//  Created by Adam Young on 25/06/2020.
//

import Foundation

public enum IdentityProviderType {
    case azureAD
    case azureADB2C
    case google
    case other

    init(wellKnownEndpoint: URL) {
        if wellKnownEndpoint.absoluteString.starts(with: WellKnownEndpointPrefix.azureADB2C) {
            self = .azureADB2C
            return
        }

        if
            let components = URLComponents(url: wellKnownEndpoint, resolvingAgainstBaseURL: false),
            let host = components.host,
            host.hasSuffix(".\(WellKnownEndpointPrefix.azureADB2CDomain)")
        {
            self = .azureADB2C
            return
        }

        if wellKnownEndpoint.absoluteString.starts(with: WellKnownEndpointPrefix.azureAD) {
            self = .azureAD
            return
        }

        if wellKnownEndpoint.absoluteString == WellKnownEndpointPrefix.google {
            self = .google
            return
        }

        self = .other
    }

    private enum WellKnownEndpointPrefix {
        static let azureAD = "https://login.microsoftonline.com/"
        static let azureADB2C = "https://login.microsoftonline.com/tfp/"
        static let azureADB2CDomain = "b2clogin.com"
        static let google = "https://accounts.google.com/.well-known/openid-configuration"
    }
}
