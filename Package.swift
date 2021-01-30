// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "HJCalendarView",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "HJCalendarView",
            targets: ["HJCalendarView"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "HJCalendarView",
            dependencies: [],
            path: "HJCalendarView"
        ),
    ]
)
