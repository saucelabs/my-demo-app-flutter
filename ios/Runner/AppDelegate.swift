import Flutter
import UIKit
import os.log

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  private static let channelName = "com.saucelabs.mydemoapp.flutter/diagnostics"
  private let log = OSLog(subsystem: "com.saucelabs.mydemoapp.flutter", category: "diagnostics")

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: AppDelegate.channelName,
        binaryMessenger: controller.binaryMessenger)
      channel.setMethodCallHandler { [weak self] call, result in
        guard let self = self else { return }
        switch call.method {
        case "crashNative":
          result(nil)
          self.crashNative()
        case "generateNativeLogs":
          let args = call.arguments as? [String: Any]
          let count = args?["count"] as? Int ?? 10
          result(self.generateNativeLogs(count: count))
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// Crashes the process from native code so the injected Backtrace SDK writes
  /// a crash report. A bad-access dereference raises `SIGSEGV`, which Crashpad
  /// captures. Dispatched async so the MethodChannel reply is delivered first.
  private func crashNative() {
    os_log("Forcing native crash for Backtrace crash-report capture", log: log, type: .error)
    DispatchQueue.main.async {
      let nullPointer = UnsafeMutablePointer<Int>(bitPattern: 0)
      nullPointer!.pointee = 42
    }
  }

  /// Emits NSLog/os_log lines that the injected TestFairy SDK records into its
  /// session log. Returns how many lines were written.
  private func generateNativeLogs(count: Int) -> Int {
    for i in 1...max(count, 1) {
      os_log("[testfairy][ios] demo log line %d/%d", log: log, type: .info, i, count)
    }
    os_log("[testfairy][ios] warning sample for TestFairy capture", log: log, type: .default)
    os_log("[testfairy][ios] error sample for TestFairy capture", log: log, type: .error)
    return count
  }
}
