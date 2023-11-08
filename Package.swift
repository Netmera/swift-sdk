// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "netmera-ios",
  platforms: [.iOS(.v12)],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "NetmeraCore",
      targets: ["NetmeraCoreWrapper"]
    ),
    .library(
      name: "NetmeraAnalytic",
      targets: ["NetmeraAnalyticWrapper"]
    ),
    .library(
      name: "NetmeraAdvertisingId",
      targets: ["NetmeraAdvertisingIdWrapper"]
    ),
    .library(
      name: "NetmeraNotificationServiceExtension",
      targets: ["NetmeraNotificationServiceExtensionWrapper"]
    ),
    .library(
      name: "NetmeraNotificationContentExtension",
      targets: ["NetmeraNotificationContentExtensionWrapper"]
    ),
    .library(
      name: "NetmeraNotification",
      targets: ["NetmeraNotificationWrapper"]
    ),
    .library(
      name: "NetmeraLocation",
      targets: ["NetmeraLocationWrapper"]
    ),
    .library(
      name: "NetmeraGeofence",
      targets: ["NetmeraGeofenceWrapper"]
    ),
    .library(
      name: "NetmeraNotificationInbox",
      targets: ["NetmeraNotificationInboxWrapper"]
    ),
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
//    .package(
//        url: "https://github.com/Swinject/Swinject.git",
//        exact: "2.8.4"
//    ),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .binaryTarget(
      name: "NetmeraCore",
      path: "Frameworks/NetmeraCore.xcframework"
    ),
    .binaryTarget(
      name: "NetmeraAnalytic",
      path: "Frameworks/NetmeraAnalytic.xcframework"
    ),
    .binaryTarget(
      name: "NetmeraAdvertisingId",
      path: "Frameworks/NetmeraAdvertisingId.xcframework"
    ),
    .binaryTarget(
      name: "NetmeraAnalyticAutotracking",
      path: "Frameworks/NetmeraAnalyticAutotracking.xcframework"
    ),
    .binaryTarget(
      name: "NetmeraLocation",
      path: "Frameworks/NetmeraLocation.xcframework"
    ),
    .binaryTarget(
      name: "NetmeraGeofence",
      path: "Frameworks/NetmeraGeofence.xcframework"
    ),
    .binaryTarget(
      name: "NetmeraNotificationCore",
      path: "Frameworks/NetmeraNotificationCore.xcframework"
    ),
    .binaryTarget(
      name: "NetmeraNotification",
      path: "Frameworks/NetmeraNotification.xcframework"
    ),
    .binaryTarget(
      name: "NetmeraNotificationInbox",
      path: "Frameworks/NetmeraNotificationInbox.xcframework"
    ),
    .binaryTarget(
      name: "NetmeraNotificationServiceExtension",
      path: "Frameworks/NetmeraNotificationServiceExtension.xcframework"
    ),
    .binaryTarget(
      name: "NetmeraNotificationContentExtension",
      path: "Frameworks/NetmeraNotificationContentExtension.xcframework"
    ),
    .binaryTarget(
      name: "Swinject",
      path: "Dependencies/Swinject.xcframework"
    ),
    .target(
      name: "NetmeraCoreWrapper",
      dependencies: [
        .target(name: "NetmeraCore", condition: .when(platforms: [.iOS])),
        .target(name: "Swinject", condition: .when(platforms: [.iOS])),
//        .product(name: "Swinject", package: "Swinject", condition: .when(platforms: [.iOS])),
      ],
      linkerSettings: [
        .linkedFramework("CoreTelephony")
      ]
    ),
    .target(name: "NetmeraAnalyticWrapper",
            dependencies: [
              .target(name: "NetmeraCoreWrapper", condition: .when(platforms: [.iOS])),
              .target(name: "NetmeraAnalytic", condition: .when(platforms: [.iOS])),
            ]),
    .target(name: "NetmeraAdvertisingIdWrapper",
            dependencies: [
              .target(name: "NetmeraAnalyticWrapper", condition: .when(platforms: [.iOS])),
              .target(name: "NetmeraAdvertisingId", condition: .when(platforms: [.iOS])),
            ]),
    .target(name: "NetmeraNotificationCoreWrapper",
            dependencies: [
              .target(name: "NetmeraAnalyticWrapper", condition: .when(platforms: [.iOS])),
              .target(name: "NetmeraNotificationCore", condition: .when(platforms: [.iOS])),
            ]),
    .target(name: "NetmeraNotificationWrapper",
            dependencies: [
              .target(name: "NetmeraNotificationCoreWrapper", condition: .when(platforms: [.iOS])),
              .target(name: "NetmeraNotification", condition: .when(platforms: [.iOS])),
            ]),
    .target(name: "NetmeraNotificationServiceExtensionWrapper",
            dependencies: [
              .target(name: "NetmeraNotificationCoreWrapper", condition: .when(platforms: [.iOS])),
              .target(name: "NetmeraNotificationServiceExtension", condition: .when(platforms: [.iOS])),
            ]),
    .target(name: "NetmeraNotificationContentExtensionWrapper",
            dependencies: [
              .target(name: "NetmeraNotificationCoreWrapper", condition: .when(platforms: [.iOS])),
              .target(name: "NetmeraNotificationContentExtension", condition: .when(platforms: [.iOS])),
            ]),
    .target(name: "NetmeraNotificationInboxWrapper",
            dependencies: [
              .target(name: "NetmeraNotificationCoreWrapper", condition: .when(platforms: [.iOS])),
              .target(name: "NetmeraNotificationInbox", condition: .when(platforms: [.iOS])),
            ]),
    .target(name: "NetmeraLocationWrapper",
            dependencies: [
              .target(name: "NetmeraAnalyticWrapper", condition: .when(platforms: [.iOS])),
              .target(name: "NetmeraLocation", condition: .when(platforms: [.iOS])),
            ]),
    .target(name: "NetmeraGeofenceWrapper",
            dependencies: [
              .target(name: "NetmeraLocationWrapper", condition: .when(platforms: [.iOS])),
              .target(name: "NetmeraGeofence", condition: .when(platforms: [.iOS])),
            ]),
  ]
)
