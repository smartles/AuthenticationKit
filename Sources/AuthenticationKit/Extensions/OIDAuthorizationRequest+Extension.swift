//
//  OIDAuthorizationRequest+Extension.swift
//  AuthenticationKit
//
//  Created by Adam Young on 25/06/2020.
//

import AppAuth
import Foundation

extension OIDAuthorizationRequest {
    convenience init(configuration: OIDServiceConfiguration, providerConfiguration: OIDProviderConfiguration,
                     loginHint: String?, redirectURL: URL) {
        let identityProviderType = IdentityProviderType(wellKnownEndpoint: providerConfiguration.wellKnownEndpoint)
        var scopes = [OIDScopeOpenID, OIDScopeEmail]

        scopes.append(contentsOf: providerConfiguration.additionalScopes)
        if case .azureADB2C = identityProviderType {
          scopes.append("offline_access")
        }

        var additionalParameters = providerConfiguration.additionalParameters
        additionalParameters["prompt"] = "login"
        if let loginHint = loginHint {
          additionalParameters["login_hint"] = loginHint
        }

        self.init(configuration: configuration, clientId: providerConfiguration.clientID, scopes: scopes,
                  redirectURL: redirectURL, responseType: OIDResponseTypeCode,
                  additionalParameters: additionalParameters)
    }
}
