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
    dependencies: [
        .package(name: "AppAuth", url: "https://github.com/openid/AppAuth-iOS.git", from: "1.4.0")
    ],
    targets: [
        .target(name: "AuthenticationKit", dependencies: ["AppAuth"]),
        .testTarget(name: "AuthenticationKitTests", dependencies: ["AuthenticationKit"])
    ]
)
