// Copyright (c) 2026 Krystian J.
// SPDX-License-Identifier: MIT

// swift-tools-version: 6.2
import Foundation
import PackageDescription

let sdkRoot = ProcessInfo.processInfo.environment["SDKROOT"]
let xcodeDeveloperDirectory = ProcessInfo.processInfo.environment["DEVELOPER_DIR"]
    ?? "/Applications/Xcode.app/Contents/Developer"
let appleTestingFramework = sdkRoot.map { "\($0)/Developer/Library/Frameworks" }
    ?? "\(xcodeDeveloperDirectory)/Platforms/MacOSX.platform/Developer/Library/Frameworks"
let appleTestingRPath = sdkRoot.map { "\($0)/Developer/usr/lib" }
    ?? "\(xcodeDeveloperDirectory)/Platforms/MacOSX.platform/Developer/usr/lib"
let swiftTestingSettings: [SwiftSetting] = [
    .unsafeFlags(["-F", appleTestingFramework]),
]
let swiftTestingLinkerSettings: [LinkerSetting] = [
    .unsafeFlags([
        "-F", appleTestingFramework,
        "-Xlinker", "-rpath", "-Xlinker", appleTestingRPath,
    ]),
]

let package = Package(
    name: "SwiftUSB",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "SwiftUSB", targets: ["SwiftUSB"]),
    ],
    targets: [
        .systemLibrary(
            name: "CLibUSB",
            path: "Sources/CLibUSB",
            pkgConfig: "libusb-1.0",
            providers: [
                .brew(["libusb"]),
                .apt(["libusb-1.0-0-dev"]),
            ]
        ),
        .target(
            name: "SwiftUSB",
            dependencies: ["CLibUSB"],
            path: "Sources/SwiftUSB"
        ),
        .testTarget(
            name: "SwiftUSBTests",
            dependencies: ["SwiftUSB"],
            path: "Tests/SwiftUSBTests",
            swiftSettings: swiftTestingSettings,
            linkerSettings: swiftTestingLinkerSettings
        ),
        .testTarget(
            name: "HardwareTests",
            dependencies: ["SwiftUSB"],
            path: "Tests/HardwareTests",
            swiftSettings: swiftTestingSettings,
            linkerSettings: swiftTestingLinkerSettings
        ),
    ]
)
