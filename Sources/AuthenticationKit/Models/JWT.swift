//
//  JWT.swift
//  AuthenticationKit
//
//  Created by Adam Young on 25/06/2020.
//

import Foundation

public struct JWT {
    private static let expireTimeWindow: TimeInterval = (5 * 60) // 5 minutes

    public let header: [String: Any]
    public let body: [String: Any]
    public let signature: String?
    public let rawValue: String

    public init(jwt: String) throws {
        let parts = jwt.components(separatedBy: ".")
        guard parts.count == 3 else {
            throw JWTError.invalidPartCount(jwt, parts.count)
        }

        self.header = try JWT.decodeJWTPart(parts[0])
        self.body = try JWT.decodeJWTPart(parts[1])
        self.signature = parts[2]
        self.rawValue = jwt
    }

    private static func decodeJWTPart(_ value: String) throws -> [String: Any] {
        guard let bodyData = value.base64UrlDecoded() else {
            throw JWTError.invalidBase64Url(value)
        }

        guard
            let json = try? JSONSerialization.jsonObject(with: bodyData, options: []),
            let payload = json as? [String: Any]
        else {
            throw JWTError.invalidJSON(value)
        }

        return payload
    }

    public init(data: Data) throws {
        guard let jwt = String(data: data, encoding: .utf8) else {
            throw JWTError.invalidData
        }

        try self.init(jwt: jwt)
    }
}

extension JWT {

    init?(fromAccessToken accessToken: String?, or idToken: String?) {
      if let accessToken = accessToken, let jwt = JWT(rawValue: accessToken) {
        self = jwt
        return
      }

      if let idToken = idToken, let jwt = JWT(rawValue: idToken) {
        self = jwt
        return
      }

      return nil
    }

}

extension JWT {
    public var isExpired: Bool {
        guard let expiresAt = expiresAt else {
            return true
        }

        return expiresAt.timeIntervalSinceNow < Self.expireTimeWindow
    }

    public var shouldRenewBy: Date {
        guard let expiresAt = expiresAt else {
            return Date()
        }

        return expiresAt.addingTimeInterval(-Self.expireTimeWindow)
    }

    public var shouldRenew: Bool {
        return shouldRenewBy.timeIntervalSinceNow < 0
    }
}

extension JWT: RawRepresentable {

  public typealias RawValue = String

  public init?(rawValue: String) {
    try? self.init(jwt: rawValue)
  }

}

extension JWT: CustomStringConvertible {

    public var description: String {
        rawValue
    }
}

public enum JWTError: LocalizedError {
    case invalidData
    case invalidBase64Url(String)
    case invalidJSON(String)
    case invalidPartCount(String, Int)
}

extension JWTError {

    public var localizedDescription: String {
        switch self {
        case .invalidData:
            return NSLocalizedString("Malformed jwt token", comment: "Malformed jwt token")

        case .invalidJSON(let value):
            return NSLocalizedString("Malformed jwt token, failed to parse JSON value from base64Url \(value)",
                                     comment: "Invalid JSON value inside base64Url")

        case .invalidPartCount(let jwt, let parts):
            return NSLocalizedString("Malformed jwt token \(jwt) has \(parts) parts when it should have 3 parts",
                                     comment: "Invalid amount of jwt parts")

        case .invalidBase64Url(let value):
            return NSLocalizedString("Malformed jwt token, failed to decode base64Url value \(value)",
                                     comment: "Invalid JWT token base64Url value")
        }
    }

}
