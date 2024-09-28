// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KingfisherNativeSVG",
    platforms: [.iOS(.v12), .tvOS(.v12), .watchOS(.v5), .macOS(.v10_14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "KingfisherNativeSVG",
            targets: ["KingfisherNativeSVG"])
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.11.0"),
        .package(url: "https://github.com/SDWebImage/svgnative-Xcode.git", from: "0.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "KingfisherNativeSVG",
            dependencies: ["Kingfisher", "KingfisherNativeSVGObjc"],
            path: "Sources",
            exclude: ["KingfisherNativeSVGObjc"]
        ),
        .target(
            name: "KingfisherNativeSVGObjc",
            dependencies: [.product(name: "svgnative", package: "svgnative-xcode")],
            path: "Sources/KingfisherNativeSVGObjc",
            cSettings: [.define("BOOST_VARIANT_DETAIL_NO_SUBSTITUTE", to: "1")],
            linkerSettings: [.linkedLibrary("xml2")]
        ),
        .testTarget(
            name: "KingfisherNativeSVGTests",
            dependencies: ["Kingfisher", "KingfisherNativeSVG"]),
    ],
    cLanguageStandard: .gnu11,
    cxxLanguageStandard: .gnucxx14
)
