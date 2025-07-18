# my-demo-app-flutter

## Introduction :

*My Demo App Flutter* is a mobile application developed using Flutter based 
on [Flutter Counter example application](https://github.com/felangel/bloc/tree/master/examples/flutter_counter). 
Modified by the Sauce Labs team, this app is designed to demonstrate the robust capabilities of Sauce Labs' 
mobile devices cloud, with a particular focus on our integration with the [Appium Flutter Integration Driver](https://github.com/AppiumTestDistribution/appium-flutter-integration-driver)

In addition to Appium, this app also supports running Flutter integration tests using native test frameworks like Espresso (for Android) and XCTest (for iOS) on Sauce Labs, providing a comprehensive testing solution for Flutter applications.

## Requirements

To build and use this demo app, ensure you have the following dependencies installed on your local machine:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Saucectl](https://docs.saucelabs.com/dev/cli/saucectl/)
- For Android applications:
    - [Java 17](https://openjdk.org/projects/jdk/17/)
    - [Android SDK](https://developer.android.com/tools/releases/platform-tools)
- For iOS applications:
    - [Xcode](https://developer.apple.com/xcode/)
    - [CocoaPods](https://cocoapods.org/)
    - A valid digital signature to build the app for real devices

To verify that all the necessary requirements are met, run the following command. This will check your system and provide a report on what
is installed and what needs to be installed:

```bash
flutter doctor
```

## Building the apps

### Install dependencies

First, install all necessary dependencies:

```bash
flutter packages get
```

Check for any outdated packages:

```bash
flutter pub outdated
```

Upgrade outdated packages to their latest major versions:

```bash
flutter pub upgrade --major-versions
```  
## Test Your Application Using Appium

At Sauce Labs, we support the [appium flutter integration driver](https://docs.saucelabs.com/mobile-apps/automated-testing/appium/appium-flutter-integration-driver/). 
You can follow the next steps to build your app for appium testing. 

#### Build the Android app

Navigate to the android directory and build the app:

```bash
cd android
gradle wrapper
./gradlew app:assembleDebug -Ptarget=`pwd`/../integration_test/appium_test.dart
```

#### Build the iOS app

For Simulator - Debug mode

```bash
flutter build ios integration_test/appium_test.dart --simulator
```

For Real Device - Release mode
   
```bash
flutter build ipa --release integration_test/appium_test.dart
```

## Test Your Application Using Native Test Frameworks
In the following part we have a step-by-step guide to prepare your application for flutter integration testsing using Android's and Apple's 
native test frameworks, `Espresso` and `XCTest`. 

#### Prepare Your Flutter Application For Android Integration Testing

1. Open your Flutter project in your favorite IDE.
2. In your Flutter app's `pubspec.yaml`, add the following dependencies:

   ```yaml
   dev_dependencies:
      integration_test:
         sdk: flutter
      flutter_test:
         sdk: flutter
   ```
3. Create an instrumentation test file in your application’s `android/app/src/androidTest/java/com/example/myapp` directory. Replace `com, example,` and `myApp` with the values from your app’s package name.

   Then, name this test file as `MainActivityTest.java` or another name of your choice.
    ```java
    package com.example.myApp;
    
    import androidx.test.rule.ActivityTestRule;
    import dev.flutter.plugins.integration_test.FlutterTestRunner;
    import org.junit.Rule;
    import org.junit.runner.RunWith;
    import com.example.myApp.MainActivity;
    
    @RunWith(FlutterTestRunner.class)
    public class MainActivityTest {
        @Rule
        public ActivityTestRule<MainActivity> rule = new ActivityTestRule<>(MainActivity.class, true, false);
    }
    ```

4. Update your application’s `myapp/android/app/build.gradle` file to ensure it uses androidx’s version of `AndroidJUnitRunner` and includes androidx libraries as a dependency.
   ```gradle
    android {
      ...
      defaultConfig {
        ...
        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
      }
    }
    dependencies {
      testImplementation 'junit:junit:4.12'
      androidTestImplementation 'androidx.test:runner:1.2.0'
      androidTestImplementation 'androidx.test.espresso:espresso-core:3.2.0'
    }
   ```
5. Create a directory called `integration_test` in the root of your Flutter project.
6. Create a file called `flutter_integration_test.dart` in the `integration_test` directory.
7. Update your testing dart file `flutter_integration_test.dart` to include the ***tearDownAll***,
   The purpose for this is to make sure we close the connection to the device after the tests have completed.
    ```dart
    import 'package:flutter/material.dart';
    import 'package:flutter_test/flutter_test.dart';
    import 'package:integration_test/integration_test.dart'; // Ensure you have this import
    // Add as app because we want to make sure the app loaded correctly on the device by calling the main function in the main dart file.
    import 'package:my_demo/main.dart' as app;
    void main() {
    
      // Ensure IntegrationTestWidgetsFlutterBinding is initialized
      final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized() as IntegrationTestWidgetsFlutterBinding;
    
    
      group('E2E Test With Flutter', (){
        tearDownAll(() async {
          // Signal that the test is complete
          binding.reportData = <String, dynamic>{
            'completed': true,
          };
        });
    
        testWidgets("First testing scenario increment 5 decrement 3", 
        (tester) async {
          app.main();
          await tester.pumpAndSettle(); // wait for app to be ready. 
          
          // ...
        });
      });
    }
   ```
8. Use the following `Gradle` commands to build an instrumentation test `.apk` file(test suite) using the `MainActivityTest.java` created in the `androidTest` directory as mentioned in step 3, **or** you can use the `make` command to build the application and build the apk files.
   ```bash title="Terminal Command"
    # Go to the android folder which contains the "gradlew" script used for building Android apps from the terminal
    pushd android
    gradle wrapper
    
    # Build an Android test APK (uses the MainActivityTest.java file created in step 1)
    ./gradlew app:assembleAndroidTest

    # Build a debug APK by passing the integration test file
    ./gradlew app:assembleDebug -Ptarget=`pwd`/../integration_test/flutter_integration_test.dart
    # Go back to the root of the project
    popd
   ```
   OR simply run:
    ```shell
    make build-android-apk-files
    ```
9. Configure `saucectl` to run the test.
    * Create a folder `.sacue` in your project root directory.
    * Inside this folder create a `flutter_integration_test_android.yaml` with the following content:
   ```yaml
   apiVersion: v1alpha
   kind: espresso
   sauce:
      concurrency: 1
   espresso:
      app: ./build/app/outputs/flutter-apk/app-debug.apk
      testApp: ./build/app/outputs/apk/androidTest/debug/app-debug-androidTest.apk
   suites:
      - name: "Sauce Labs Espresso with flutter integration tests"
        testOptions:
          class:
            - com.example.my_demo_app_flutter.MainActivityTest
        devices:
          - name: "Google Pixel.*"
   artifacts:
      download:
        when: always
        match:
          - junit.xml
        directory: ./
   ```
    * Run the following commands to start the test on Sauce Labs
   ```bash title="Terminal Command"
   saucectl configure -u USERNAME -a ACCESS_KEY
   saucectl run -c sauceconnect/flutter_integration_test.yaml
   ```
    * Check the status of your test on `app.saucelabs.com`
   ``` bash title="saucectl run command output"
   12:24:52 INF Running Espresso in Sauce Labs
                                         (.                          
                                          #.                           
                                          #.                           
                              .####################                    
                            #####////////*******/######                
                          .##///////*****************###/              
                         ,###////*********************###              
                         ####//***********************####             
                          ###/************************###              
                           ######********************###. ##           
                              (########################  ##     ##     
                                      ,######(#*         ##*   (##     
                                  /############*          #####        
                              (########(  #########(    ###            
                            .#######,    */  ############              
                         ,##########  %#### , ########*                
                       *### .#######/  ##  / ########                  
                      ###   .###########//###########                  
                  ######     ########################                  
                (#(    *#(     #######.    (#######                    
                       ##,    /########    ########                    
                              *########    ########                    
    _____        _    _  _____ ______    _____ _      ____  _    _ _____  
   / ____|  /\  | |  | |/ ____|  ____|  / ____| |    / __ \| |  | |  __ \
   | (___   /  \ | |  | | |    | |__    | |    | |   | |  | | |  | | |  | |
   \___ \ / /\ \| |  | | |    |  __|   | |    | |   | |  | | |  | | |  | |
   ____) / ____ \ |__| | |____| |____  | |____| |___| |__| | |__| | |__| |
   |_____/_/    \_\____/ \_____|______|  \_____|______\____/ \____/|_____/
      
   12:24:52 INF Checking if ...../my-demo-app-flutter/build/app/outputs/flutter-apk/app-debug.apk has already been uploaded previously
   12:24:52 INF Checksum: 1df0b6684973536fef4ae653d89661d6c48d6f699091511515b69735d6a80fbd
   12:27:26 INF Application uploaded. durationMs=153173 storageId=6849a64a-3c51-4423-87f2-b3660c972a36
   12:27:26 INF Checking if ...../build/app/outputs/apk/androidTest/debug/app-debug-androidTest.apk has already been uploaded previously
   12:27:26 INF Checksum: b5b15cb741b78fe7a5df171406c17ec9ea8fd6ac52623abf7a8df519270e281d
   12:27:26 INF Skipping upload, using storage:635a7a46-c1fc-4c43-9a05-60e09a2163b8
   12:27:26 INF Launching workers. concurrency=1
   12:27:26 INF Starting suite. region=us-west-1 suite="Sauce Labs Espresso with flutter integration tests"
   12:27:27 INF Suite started. deviceId= deviceName="Google Pixel.*" platform=Android platformVersion= private=false suite="Sauce Labs Espresso with flutter integration tests" url=https://app.saucelabs.com/tests/4b52d0880d5d41579d669a66fdca2da0
   12:27:36 INF Suites in progress: 1
   12:27:46 INF Suites in progress: 1
   12:27:56 INF Suites in progress: 1
   12:28:06 INF Suites in progress: 1
   12:28:16 INF Suites in progress: 1
   12:28:26 INF Suites in progress: 1
   12:28:27 INF Suite finished. passed=true suite="Sauce Labs Espresso with flutter integration tests" url=https://app.saucelabs.com/tests/4b52d0880d5d41579d669a66fdca2da0
      
   Results:
          Name                                                  Duration    Status    Platform    Device            Attempts  
   ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   ✔    Sauce Labs Espresso with flutter integration tests        1m0s    passed    Android     Google Pixel.*           1  
   ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   ✔    All tests have passed                                     1m1s
      
   Build Link: https://app.saucelabs.com/builds/rdc/159d98f0223246e59dd172bad78573cc
   ```

#### Prepare Your Flutter Application For iOS Integration Testing

1. Launch the Xcode Application.
2. On Xcode, open the `ios/Runner.xcworkspace` in your flutter project, inside the ios folder.
3. Create a test target if you do not already have one via `File > New > Target...` and select `Unit Testing Bundle`.
4. Change the `Product Name` to `RunnerTests`.
5. Make sure `Target to be Tested` is set to `Runner` and language is set to `Objective-C`.
6. Make sure that the `iOS Deployment Target` of `RunnerTests` within the `Build Settings` section is the same as `Runner`.
7. In the new target, add a test file called `RunnerTests.m` (or any name of your choice) and replace the file content with the
   following :
    ```objective-c 
    @import XCTest;
    @import integration_test;

    INTEGRATION_TEST_IOS_RUNNER(RunnerTests)
   ```
8. Select your `Team` for both Targets in the `Signing & Capabilities` section.
9. Now you can open the Flutter project in your favorite IDE.
10. Update the `ios/Podfile` file by embedding in the existing Runner target :
   ```ruby
   target 'Runner' do
      # Do not change existing lines.
      ...
      target 'RunnerTests' do
        inherit! :search_paths
      end
   end
   ```
11. Create a directory called `integration_test` in the root of your Flutter project.
12. Create a file called `flutter_integration_test.dart` in the `integration_test` directory.
13. Update your testing dart file `flutter_integration_test.dart` to include the ***tearDownAll***,
    The purpose for this is to make sure we close the connection to the device after the tests have completed.
     ```dart
     import 'package:flutter/material.dart';
     import 'package:flutter_test/flutter_test.dart';
     import 'package:integration_test/integration_test.dart'; // Ensure you have this import
     // Add as app because we want to make sure the app loaded correctly on the device by calling the main function in the main dart file.
     import 'package:my_demo/main.dart' as app;
     void main() {
    
       // Ensure IntegrationTestWidgetsFlutterBinding is initialized
       final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized() as IntegrationTestWidgetsFlutterBinding;
    
    
       group('E2E Test With Flutter', (){
         tearDownAll(() async {
           // Signal that the test is complete
           binding.reportData = <String, dynamic>{
             'completed': true,
           };
         });
    
         testWidgets("First testing scenario increment 5 decrement 3", 
         (tester) async {
           app.main();
           await tester.pumpAndSettle(); // wait for app to be ready. 
          
           // ...
         });
       });
     }
    ```
14. To build `integration_test/flutter_integration_test.dart` from the command line, run.
    ```bash title="Terminal Command"
     flutter build ios --config-only integration_test/flutter_integration_test.dart
    ```
15. Execute the following bash script at the root of your Flutter app, this bash script will build the flutter app and generate
    the `xctestrun` file which contains all the necessary configs to successfully trigger the integration test, **or** you can use the `make` command to build the application and build the ipa file.
    ```shell
    output="../build/ios_integration"
    product="build/ios_integration/Build/Products"
    
    flutter clean
    
    # Pass --simulator if building for the simulator.
    flutter build ios integration_test/flutter_integration_test.dart --release
    
    # move to the ios folder
    pushd ios
    # run the xcodebuild command to build the app for testing 
    xcodebuild build-for-testing \
    -workspace Runner.xcworkspace \
    -scheme Runner \
    -xcconfig Flutter/Release.xcconfig \
    -configuration Release \
    -derivedDataPath \
    $output -sdk iphoneos
    # go back the flutter application root folder
    popd
    
    # Compile the app into ipa file:
    # Open the product folder to get the xctestrun file and the application folder 
    pushd $product
    mkdir Payload
    cp -r Release-iphoneos/Runner.app Payload
    zip -r Runner.ipa Payload
    popd
    
    ```
    OR simply run:
    ```shell
    make build-ios-ipa-files
    ```
16. Configure `saucectl` to run the test.
  * Create a folder `.sauce` in your project root directory.
  * Inside this folder create a `flutter_integration_test_ios.yaml` with the following content:
    ```yaml
    apiVersion: v1alpha
    kind: xctest
    sauce:
       concurrency: 1
    xctest:
       app: ...../flutter/my-demo-app-flutter/build/ios_integration/Build/Products/Runner.ipa
       xcTestRunFile: ....../flutter/my-demo-app-flutter/build/ios_integration/Build/Products/Runner_iphoneos18.1-arm64.xctestrun
    suites:
       - name: "Sauce Labs XCTest with flutter integration tests"
         devices:
           - name: ".*"
    artifacts:
       download:
         when: always
         match:
           - junit.xml
         directory: ./
    ```
  * Run the following commands to start the test on Sauce Labs
    ```bash title="Terminal Command"
    saucectl configure -u USERNAME -a ACCESS_KEY
    saucectl run -c .sauce/flutter_integration_test_ios.yaml
    ```
  * Check the status of your test on `app.saucelabs.com`
