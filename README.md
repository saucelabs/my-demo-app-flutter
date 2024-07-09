# my-demo-app-flutter

## Introduction :

*My Demo App Flutter* is a mobile application developed using Flutter based 
on [Flutter Counter example application](https://github.com/felangel/bloc/tree/master/examples/flutter_counter). 
Modified by the Sauce Labs team, this app is designed to demonstrate the robust capabilities of Sauce Labs' 
mobile devices cloud, with a particular focus on our integration with the [Appium Flutter Integration Driver](https://github.com/AppiumTestDistribution/appium-flutter-integration-driver).

You can find additional code examples in our [training repository](https://github.com/saucelabs-training/demo-js/tree/main/webdriverio/appium-app/examples/appium-flutter-integration) 

<h1 align="center">
	<br>
	<img src="Logo.png" alt="Flutter-Appium">
	<br>
</h1>

## Requirements

To build and use this demo app, ensure you have the following dependencies installed on your local machine:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
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

### Build the Android app

Navigate to the android directory and build the app:

```bash
cd android
./gradlew app:assembleDebug -Ptarget=`pwd`/../integration_test/appium_test.dart
```

### Build the iOS app

For Simulator - Debug mode

```bash
flutter build ios integration_test/appium_test.dart --simulator
```

For Real Device - Release mode
   
```bash
flutter build ipa --release integration_test/appium_test.dart
```