// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Scriptorium",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "Scriptorium", targets: ["Scriptorium"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "Scriptorium",
            dependencies: [],
            path: "Scriptorium"
        )
    ]
)
