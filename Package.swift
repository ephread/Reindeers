// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// Starting with Xcode 12, we don't need to depend on our own libxml2 target
#if swift(>=5.3)
let dependencies: [Target.Dependency] = []
#else
let dependencies: [Target.Dependency] = ["libxml2"]
#endif

#if swift(>=5.2)
let pkgConfig: String? = nil
#else
let pkgConfig: String? = "libxml-2.0"
#endif

#if swift(>=5.2)
let provider: [SystemPackageProvider] = []
#else
let provider: [SystemPackageProvider] = [
    .brew(["libxml2"])
]
#endif

let package = Package(
    name: "Reindeers",
    products: [
        .library(
            name: "Reindeers",
            targets: ["Reindeers"]),
    ],
    dependencies: [],
    targets: [
        .systemLibrary(
            name: "libxml2",
            path: "Modules",
            pkgConfig: pkgConfig,
            providers: provider
        ),
        .target(
            name: "Reindeers",
            dependencies: [],
            path: "Sources"),
    ]
)
