import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let displayZoomChannel = FlutterMethodChannel(
            name: "flutter_zoom_checker",
            binaryMessenger: controller.binaryMessenger)
        
        displayZoomChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case "getDisplayZoom":
                result(UIScreen.main.nativeScale / UIScreen.main.scale)
            default:
                result(FlutterMethodNotImplemented)
            }
        })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  
}

