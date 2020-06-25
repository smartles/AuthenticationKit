//
//  JWT+Claims.swift
//  AuthenticationKit
//
//  Created by Adam Young on 25/06/2020.
//

import Foundation

extension JWT {
    public func claim(name: String) -> Claim {
        let value = self.body[name]
        return Claim(value: value)
    }

    public var expiresAt: Date? {
        return claim(name: "exp").date
    }

    public var issuer: String? {
        return claim(name: "iss").string
    }

    public var subject: String? {
        return claim(name: "sub").string
    }

    public var audience: [String]? {
        return claim(name: "aud").array
    }

    public var issuedAt: Date? {
        return claim(name: "iat").date
    }

    public var notBefore: Date? {
        return claim(name: "nbf").date
    }

    public var identifier: String? {
        return claim(name: "jti").string
    }

    public var expired: Bool {
        guard let date = self.expiresAt else {
            return false
        }

        return date.compare(Date()) != ComparisonResult.orderedDescending
    }

    public var email: String? {
        if let email = claim(name: "upn").string {
            return email
        }

        if let emails = claim(name: "emails").value as? [String], let email = emails.first {
            return email
        }

        if let email = claim(name: "email").string {
            return email
        }

        return nil
    }
}
