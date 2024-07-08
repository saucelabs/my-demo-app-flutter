# my-demo-app-flutter

*My Demo App* is a... demo app!
It was built by the Sauce Labs team to showcase the product capabilities of the Sauce Labs mobile devices cloud, focusing on our Appium flutter driver integration.

Test this with [Appium Flutter Integration Driver](https://github.com/AppiumTestDistribution/appium-flutter-integration-driver).

You can find additional code examples in our [training repository](https://github.com/saucelabs-training/demo-java)

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
   ./gradlew app:assembleDebug -Ptarget=`pwd`/../integration_test/appium.dart
   ```

## Build the iOS app:
   For Simulator - Debug mode
   ```bash
   flutter build ios integration_test/appium.dart --simulator
   ```
   For Real Device - Release mode
   
```bash
   flutter build ipa --release integration_test/test.dart
   ```