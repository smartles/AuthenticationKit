// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "AuthenticationKit",
  platforms: [
    .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)
  ],
  products: [
    .library(name: "AuthenticationKit", targets: ["AuthenticationKit"]),
  ],
  targets: [
    .target(name: "AuthenticationKit", dependencies: ["OIDAuthentication"]),

    .target(name: "OIDAuthentication", dependencies: []),
    .testTarget(name: "OIDAuthenticationTests", dependencies: ["OIDAuthentication"]),
  ]
)
