// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "WorkingExamples",
  platforms: [
    .macOS(.v11),
    .iOS(.v14),
  ],
  products: [
    .library(
      name: "WorkingExamples",
      targets: ["WorkingExamples"]),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "WorkingExamples",
      dependencies: [],
      path: "Sources/WorkingExamples"
    ),
    .testTarget(
      name: "WorkingExamplesTests",
      dependencies: ["WorkingExamples"]),
  ]
)
