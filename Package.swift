// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "w3w-swift-components-address-validator",
    platforms: [
      .watchOS(.v6), .iOS(.v13)
    ],
    products: [
      // Products define the executables and libraries a package produces, and make them visible to other packages.
      .library(name: "W3WSwiftComponentsAddressValidator", targets: ["W3WSwiftComponentsAddressValidator"]),
      .library(name: "W3WSwiftUIComponentsAddressValidator", targets: ["W3WSwiftUIComponentsAddressValidator"]),
    ],
    dependencies: [
      .package(url: "git@github.com:what3words/w3w-swift-address-validators.git", "0.1.0"..<"0.9.0"),
      .package(url: "https://github.com/what3words/w3w-swift-wrapper.git", "3.7.2"..<"4.0.0"),
      .package(url: "https://github.com/what3words/w3w-swift-components.git", "2.3.0"..<"3.0.0"),
      .package(url: "https://github.com/what3words/w3w-swift-interface-elements.git", "0.1.0"..<"0.9.0"),
      .package(url: "https://github.com/what3words/w3w-swift-design.git", "0.1.0"..<"0.9.0"),
    ],
    targets: [
      // Targets are the basic building blocks of a package. A target can define a module or a test suite. Targets can depend on other targets in this package, and on products in packages this package depends on.
      .target(name: "W3WSwiftComponentsAddressValidator", dependencies: [.product(name: "W3WSwiftApi", package: "w3w-swift-wrapper"), .product(name: "W3WSwiftDesign", package: "w3w-swift-design"), .product(name: "W3WSwiftAddressValidators", package: "w3w-swift-address-validators"), .product(name: "W3WSwiftInterfaceElements", package: "w3w-swift-interface-elements"), .product(name: "W3WSwiftComponents", package: "w3w-swift-components")]),
      .target(name: "W3WSwiftUIComponentsAddressValidator", dependencies: [.product(name: "W3WSwiftApi", package: "w3w-swift-wrapper"), .product(name: "W3WSwiftDesign", package: "w3w-swift-design"), .product(name: "W3WSwiftAddressValidators", package: "w3w-swift-address-validators"), .product(name: "W3WSwiftUIInterfaceElements", package: "w3w-swift-interface-elements")], resources: [.process("Resources")]),

      .testTarget(name: "w3w-swift-components-address-validatorTests", dependencies: ["W3WSwiftComponentsAddressValidator"]),
    ]
)
