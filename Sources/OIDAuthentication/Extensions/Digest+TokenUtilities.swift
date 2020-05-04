//
//  File.swift
//  
//
//  Created by Adam Young on 23/09/2019.
//

import CryptoKit
import Foundation

extension Digest {

  var bytes: [UInt8] {
    Array(makeIterator())
  }

  var data: Data {
    Data(bytes)
  }

}
