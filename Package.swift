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
        .systemLibrary(
            name: "gstreamer-net",
            pkgConfig: "gstreamer-net-1.0",
            providers: [
                .apt(["gstreamer"]),
                .brew(["gstreamer"])
            ]
        ),
        .systemLibrary(
            name: "gio",
            pkgConfig: "gio-2.0",
            providers: [
                .apt(["gstreamer"]),
                .brew(["gstreamer"])
            ]
        ),
        .target(
            name: "gstreamer-swift",
            dependencies: ["gstreamer", "gstreamer-net", "gio"]),
        .testTarget(
            name: "gstreamer-swift-tests",
            dependencies: ["gstreamer-swift"]),
    ]
)
