// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ReleaseNotes",
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "ReleaseNotes",
            plugins: [
                .plugin(name: "Swift-DocC Plugin", package: "swift-docc-plugin")
            ]
        )
    ]
)
