// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "gosposhlina-package",
    platforms: [.macOS(.v13), .iOS(.v15), .watchOS(.v9)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "gosposhlina-package",
            targets: ["gosposhlina-package"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "gosposhlina-package"),
        .testTarget(
            name: "gosposhlina-packageTests",
            dependencies: ["gosposhlina-package"]),
    ]
)
