// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftDataInExecutableSwiftPackage",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .executable(name: "SwiftDataInExecutableSwiftPackageCMD",
                    targets: ["CMD"]),
        .executable(name: "SwiftDataInExecutableSwiftPackageGUI",
                    targets: ["GUI"])],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "CMD",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .target(name: "Shared")
            ],
            linkerSettings: [
                .unsafeFlags( ["-Xlinker", "-sectcreate",
                               "-Xlinker", "__TEXT",
                               "-Xlinker", "__info_plist",
                               "-Xlinker", "Resources/Info.plist"] )
            ]
        ),
        .executableTarget(
            name: "GUI",
            dependencies: [
                .target(name: "Shared")
            ],
            linkerSettings: [
                .unsafeFlags( ["-Xlinker", "-sectcreate",
                               "-Xlinker", "__TEXT",
                               "-Xlinker", "__info_plist",
                               "-Xlinker", "Resources/Info.plist"] )
            ]
        ),
        .target(name: "Shared")
    ]
)
