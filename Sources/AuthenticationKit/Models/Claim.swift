//
//  Claim.swift
//  AuthenticationKit
//
//  Created by Adam Young on 25/06/2020.
//

import Foundation

public struct Claim {
    public let value: Any?

    public var rawValue: Any? {
        value
    }

    public var string: String? {
        value as? String
    }

    public var double: Double? {
        let double: Double?
        if let string = self.string {
            double = Double(string)
        } else {
            double = self.value as? Double
        }

        return double
    }

    public var integer: Int? {
        let integer: Int?
        if let string = self.string {
            integer = Int(string)
        } else if let double = self.value as? Double {
            integer = Int(double)
        } else {
            integer = self.value as? Int
        }

        return integer
    }

    public var date: Date? {
        guard let timestamp: TimeInterval = self.double else {
            return nil
        }

        return Date(timeIntervalSince1970: timestamp)
    }

    public var array: [String]? {
        if let array = value as? [String] {
            return array
        }

        if let value = self.string {
            return [value]
        }

        return nil
    }
}
