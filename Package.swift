// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PetCoreKitSPM",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "PetCoreKitSPM",
            targets: ["PetCoreKitSPM"]),
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory", from: "2.3.1"),
        .package(path: "../SQAUtility"),
        .package(path: "../SQAServices"),
        .package(path: "../Shared_kit")
    ],
    targets: [
        .target(
            name: "PetCoreKitSPM",
            dependencies: [
                .product(name: "Factory", package: "Factory"),
                "SQAUtility",
                "SQAServices",
                "Shared_kit"
            ]),
        .testTarget(
            name: "PetCoreKitSPMTests",
            dependencies: ["PetCoreKitSPM"]
        ),
    ]
)
