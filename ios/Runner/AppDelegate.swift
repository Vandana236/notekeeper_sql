import UIKit
import Flutter

@main
@objc class AppDelegate:
FlutterAppDelegate {

  private let channel =
      "battery_channel"

  override func application(

    _ application: UIApplication,

    didFinishLaunchingWithOptions
    launchOptions:
    [UIApplication.LaunchOptionsKey:
    Any]?

  ) -> Bool {

    let controller :
    FlutterViewController =
    window?.rootViewController
    as! FlutterViewController

    let batteryChannel =
    FlutterMethodChannel(

      name: channel,

      binaryMessenger:
      controller.binaryMessenger
    )

    batteryChannel
        .setMethodCallHandler {

      (call, result) in

      if call.method ==
          "getBatteryLevel" {

        UIDevice.current
            .isBatteryMonitoringEnabled
            = true

        let batteryLevel =
            Int(
          UIDevice.current
              .batteryLevel * 100
        )

        result(batteryLevel)

      } else {

        result(
          FlutterMethodNotImplemented
        )
      }
    }

    GeneratedPluginRegistrant
        .register(with: self)

    return super.application(
      application,
      didFinishLaunchingWithOptions:
      launchOptions
    )
  }
}