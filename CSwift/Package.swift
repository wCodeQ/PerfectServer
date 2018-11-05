// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CSwift",
    products: [
        .library(
            name: "CSwift",
            type: .`dynamic`,
            targets: ["CSwift"]),
    ],
    targets: [
        .target(
            name: "CSwift",
            dependencies: []),
        .testTarget(
            name: "CSwiftTests",
            dependencies: ["CSwift"]),
    ]
)
