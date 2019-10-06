// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "HJCalendarView",
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
