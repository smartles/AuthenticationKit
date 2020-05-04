//
//  Data+TokenUtilities.swift
//  AuthenticationKit
//
//  Created by Adam Young on 23/09/2019.
//

import Foundation

extension Data {

  init?(randomOfLength length: UInt) throws {
    var bytes = [UInt8](repeating: 0, count: Int(length))
    let status = SecRandomCopyBytes(kSecRandomDefault, Int(length), &bytes)
    guard status == errSecSuccess else {
      return nil
    }

    self.init(bytes)
  }

  func base64EncodedStringNoPadding(options: Base64EncodingOptions = []) -> String {
    self.base64EncodedString(options: options)
      .replacingOccurrences(of: "+", with: "-")
      .replacingOccurrences(of: "/", with: "_")
      .replacingOccurrences(of: "=", with: "")
  }

}
