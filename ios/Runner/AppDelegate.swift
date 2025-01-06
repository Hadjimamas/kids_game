import UIKit
import Flutter
import GoogleMobileAds
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GADMobileAds.sharedInstance().start(completionHandler: nil) 
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
