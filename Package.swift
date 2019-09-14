// swift-tools-version:5.1
import PackageDescription

let package = Package(
  name: "WorkingExamples",
  platforms: [
   .macOS(.v10_15), .iOS(.v13),
  ],
  products: [
    .library(
      name: "WorkingExamples",
      targets: ["SwiftUIWorkingExamples"]),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "SwiftUIWorkingExamples",
      dependencies: [],
      path: "Sources/WorkingExamples"
    ),
    .testTarget(
      name: "WorkingExamplesTests",
      dependencies: ["SwiftUIWorkingExamples"]),
  ]
)
