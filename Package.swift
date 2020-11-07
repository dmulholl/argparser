// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "argparser",
    products: [
        .library(
            name: "ArgParser",
            targets: ["ArgParser"]
        ),
    ],
    targets: [
        .target(
            name: "ArgParser",
            dependencies: []
        ),
        .target(
            name: "BasicExample",
            dependencies: ["ArgParser"]
        ),
        .target(
            name: "CommandExample",
            dependencies: ["ArgParser"]
        ),
        .testTarget(
            name: "Tests",
            dependencies: ["ArgParser"]
        ),
    ]
)
