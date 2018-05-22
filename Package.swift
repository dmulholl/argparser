// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Janus",
    products: [
        .library(
            name: "Janus",
            targets: ["Janus"]
        ),
    ],
    targets: [
        .target(
            name: "Janus",
            dependencies: []
        ),
        .target(
            name: "JanusExample",
            dependencies: ["Janus"]
        ),
        .testTarget(
            name: "JanusTests",
            dependencies: ["Janus"]
        ),
    ]
)
