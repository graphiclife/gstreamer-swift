// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "gstreamer-swift",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .library(
            name: "gstreamer-swift",
            targets: ["gstreamer-swift"]),
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .systemLibrary(
            name: "gstreamer",
            pkgConfig: "gstreamer-1.0",
            providers: [
                .apt(["gstreamer"]),
                .brew(["gstreamer"])
            ]
        ),
        .target(
            name: "gstreamer-swift",
            dependencies: ["gstreamer"]),
        .testTarget(
            name: "gstreamer-swift-tests",
            dependencies: ["gstreamer-swift"]),
    ]
)
