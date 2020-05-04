//
//  JSONDecoder+Default.swift
//  AuthenticationKit
//
//  Created by Adam Young on 23/09/2019.
//

import Foundation

extension JSONDecoder {

  static var `default`: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }

}
