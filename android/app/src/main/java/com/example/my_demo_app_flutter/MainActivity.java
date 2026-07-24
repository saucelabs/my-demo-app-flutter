package com.example.my_demo_app_flutter;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "com.saucelabs.mydemoapp.flutter/diagnostics";
    private static final String TAG = "MyDemoAppDiagnostics";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    switch (call.method) {
                        case "crashNative":
                            result.success(null);
                            crashNative();
                            break;
                        case "generateNativeLogs":
                            Integer count = call.argument("count");
                            result.success(generateNativeLogs(count == null ? 10 : count));
                            break;
                        default:
                            result.notImplemented();
                    }
                });
    }

    /**
     * Throws an uncaught {@link RuntimeException} on the main thread so the
     * process crashes for real. Rethrowing inside the MethodChannel handler
     * would be swallowed by the platform-channel machinery, so we post to the
     * main looper to escape that try/catch. The injected Backtrace SDK captures
     * the resulting crash into {@code cache/rdc-backtrace/crashpad/*}.
     */
    private void crashNative() {
        Log.e(TAG, "Forcing native crash for Backtrace crash-report capture");
        new Handler(Looper.getMainLooper()).post(() -> {
            throw new RuntimeException(
                    "Intentional native crash triggered from My Demo App Flutter");
        });
    }

    /**
     * Emits a burst of logcat lines that the injected TestFairy SDK records
     * into {@code files/rdc-testfairy/testfairy.jsonl}. Returns how many lines
     * were written.
     */
    private int generateNativeLogs(int count) {
        for (int i = 1; i <= count; i++) {
            Log.i(TAG, "[testfairy][android] demo log line " + i + "/" + count
                    + " ts=" + System.currentTimeMillis());
        }
        Log.w(TAG, "[testfairy][android] warning sample for TestFairy capture");
        Log.e(TAG, "[testfairy][android] error sample for TestFairy capture");
        return count;
    }
}
