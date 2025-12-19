// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MisDocumentosAI",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "MisDocumentosAI", targets: ["MisDocumentosAI"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "MisDocumentosAI",
            dependencies: [],
            path: "MisDocumentosAI"
        )
    ]
)
