//
//  Package.swift
//  Shortcuts
//
//  Created by Kenna Blackburn on 2/7/26.
//

// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Shortcuts",
    platforms: [.macOS(.v26)],
    products: [
        .library(
            name: "Shortcuts",
            targets: ["Shortcuts"],
        ),
    ],
    targets: [
        .target(
            name: "Helpers",
        ),
        .target(
            name: "Shortcuts",
            dependencies: ["Helpers"],
        ),
        .testTarget(
            name: "ShortcutsTests",
            dependencies: ["Shortcuts"],
        ),
    ],
)
