// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HoopProxyManager",
    platforms: [
        .macOS(.v13)  // Targeting macOS 13 Ventura for latest Swift features
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/LebJe/TOMLKit.git", from: "0.5.0"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "5.0.0-beta.rc"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "HoopProxyManager",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "TOMLKit", package: "TOMLKit"),
                .product(name: "JWTKit", package: "jwt-kit"),
            ],
            swiftSettings: [
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release)),
                .unsafeFlags(["-Osize"], .when(configuration: .release)),
            ]
        ),
        .testTarget(name: "HoopProxyManagerTests", dependencies: ["HoopProxyManager"]),
    ]
)
