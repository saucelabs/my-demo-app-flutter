# my-demo-app-flutter

*My Demo App Flutter* is a mobile application developed using Flutter based 
on [Flutter Counter example application](https://github.com/felangel/bloc/tree/master/examples/flutter_counter). 
Modified by the Sauce Labs team, this app is designed to demonstrate the robust capabilities of Sauce Labs' 
mobile devices cloud, with a particular focus on our integration with the [Appium Flutter Integration Driver](https://github.com/AppiumTestDistribution/appium-flutter-integration-driver).

You can find additional code examples in our [training repository](https://github.com/saucelabs-training/demo-js/tree/main/webdriverio/appium-app/examples/appium-flutter-integration) 

<h1 align="center">
	<br>
	<img src="Logo.png" alt="Flutter-Appium">
	<br>
	<br>
	<br>
</h1>

## Build the Android app:
    
   ```bash
   cd android
   ./gradlew app:assembleDebug -Ptarget=`pwd`/../integration_test/appium_test.dart
   ```

## Build the iOS app:
   For Simulator - Debug mode
   ```bash
   flutter build ios integration_test/appium_test.dart --simulator
   ```
   For Real Device - Release mode
   
```bash
   flutter build ipa --release integration_test/test.dart
   ```