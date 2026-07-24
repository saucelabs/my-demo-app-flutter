import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// {@template diagnostics_service}
/// Produces the on-device artifacts that Sauce Labs Real Device Cloud
/// collects during a session (the destructive-read artifact group):
///
/// * **Crash reports** — triggers a real, unrecoverable process crash so the
///   injected Backtrace SDK writes a crash file to the app cache
///   (`cache/rdc-backtrace/crashpad/*` on Android, the crash directory on iOS).
///   A crash must reach the native layer; a Dart exception caught by the
///   Flutter framework is not enough, so [crashNative] hops to native code.
/// * **TestFairy logs** — emits console/logcat/NSLog output and app activity so
///   the injected TestFairy SDK records events into
///   `files/rdc-testfairy/testfairy.jsonl`.
///
/// The Backtrace and TestFairy SDKs are injected by RDC at install time (when
/// `crashCollectionEnabled` / `backtraceInjectionEnabled` / `testfairyEnabled`
/// are set), so this app only has to create the conditions the SDKs capture.
/// {@endtemplate}
class DiagnosticsService {
  /// {@macro diagnostics_service}
  const DiagnosticsService([this._channel = _defaultChannel]);

  static const MethodChannel _defaultChannel =
      MethodChannel('com.saucelabs.mydemoapp.flutter/diagnostics');

  final MethodChannel _channel;

  /// Crashes the process from the native layer so the Backtrace SDK captures
  /// a crash report. On Android this throws an uncaught `RuntimeException` on
  /// the main thread; on iOS it raises a fatal signal. The app will terminate.
  Future<void> crashNative() async {
    debugPrint('[diagnostics] Triggering native crash for Backtrace capture');
    await _channel.invokeMethod<void>('crashNative');
  }

  /// Crashes the app from the Dart side by throwing an uncaught error, which
  /// Flutter reports through [FlutterError.onError]. Exercises the Dart error
  /// path in addition to the native crash path. Never returns normally.
  Never crashDart() {
    debugPrint('[diagnostics] Triggering Dart-level crash');
    throw StateError(
      'Intentional Dart crash triggered from My Demo App Flutter',
    );
  }

  /// Emits a burst of native log lines (logcat / NSLog) plus Dart logs so the
  /// TestFairy SDK records session log events. Returns the number of lines the
  /// native side reported writing.
  Future<int> generateTestFairyLogs({int count = 10}) async {
    debugPrint('[diagnostics] Generating $count TestFairy log lines');
    for (var i = 1; i <= count; i++) {
      // Flutter routes print/debugPrint to logcat (Android) and os_log (iOS),
      // both of which TestFairy mirrors into testfairy.jsonl.
      debugPrint('[testfairy][dart] demo log line $i/$count '
          'ts=${DateTime.now().toIso8601String()}');
    }
    final written = await _channel.invokeMethod<int>(
      'generateNativeLogs',
      <String, dynamic>{'count': count},
    );
    return written ?? 0;
  }
}
