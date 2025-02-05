DERIVED_DATA_PATH=../build/ios_integ
OUTPUT_DIR=./build/ios_integ/Build/Products
FLUTTER_INTEGRATION_TEST_DART_FILE=$(realpath integration_test/flutter_integration_test.dart)

build-for-testing:
	cd ios && xcodebuild \
	  -workspace Runner.xcworkspace \
	  -scheme Runner \
	  -sdk iphoneos \
	  -xcconfig Flutter/Release.xcconfig \
	  -configuration Release \
	  -derivedDataPath $(DERIVED_DATA_PATH) \
	  build-for-testing

build-ios-ipa-files: build-for-testing
	cd $(OUTPUT_DIR) \
	&& mkdir Payload \
	&& cp -r Release-iphoneos/Runner.app Payload \
	&& zip -r Runner.ipa Payload

build-android-apk-files:
	pushd android \
    && ./gradlew app:assembleAndroidTest \
    && ./gradlew app:assembleDebug -Ptarget="$(FLUTTER_INTEGRATION_TEST_DART_FILE)"


