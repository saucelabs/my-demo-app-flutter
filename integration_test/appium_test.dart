import 'package:appium_flutter_server/appium_flutter_server.dart';
import 'package:bloc/bloc.dart';
import 'package:my_demo_app_flutter/app.dart';
import 'package:my_demo_app_flutter/counter_observer.dart';

/// Entry point used to drive the app with **Appium** via the
/// [Appium Flutter Integration Driver](https://github.com/AppiumTestDistribution/appium-flutter-integration-driver).
///
/// [initializeTest] boots [CounterApp] with an embedded Appium Flutter server
/// on the device, so an Appium client can find widgets by key / semantics /
/// text and tap them — including the Diagnostics menu that produces the RDC
/// crash-report and TestFairy-log artifacts. The actual test steps live in the
/// Appium client (WebdriverIO, Java, Python, …), not in this file.
void main() {
  // Mirror main.dart so Bloc state changes print to the console. The injected
  // TestFairy SDK mirrors that console output into its session log, so counter
  // interactions during an Appium run also contribute TestFairy events.
  Bloc.observer = const CounterObserver();

  initializeTest(app: const CounterApp());
}
