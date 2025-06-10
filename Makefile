DERIVED_DATA_PATH=../build/ios_integ
OUTPUT_DIR=./build/ios_integ/Build/Products
FLUTTER_INTEGRATION_TEST_DART_FILE=$(realpath integration_test/flutter_integration_test.dart)
build-ios-release:
	flutter build ios $(FLUTTER_INTEGRATION_TEST_DART_FILE) --release
build-for-testing: build-ios-release
	cd ios \
	&& xcodebuild \
	  -workspace Runner.xcworkspace \
	  -scheme Runner \
	  -sdk iphoneos \
	  -xcconfig Flutter/Release.xcconfig \
	  -configuration Release \
	  -derivedDataPath $(DERIVED_DATA_PATH) \
	  build-for-testing

build-ios-ipa-files: build-for-testing
	cd $(OUTPUT_DIR) \
	&& mkdir -p Payload \
	&& cp -r Release-iphoneos/Runner.app Payload \
	&& zip -r Runner.ipa Payload

build-android-apk-files:
	pushd android \
    && gradle wrapper \
    && ./gradlew app:assembleAndroidTest \
    && ./gradlew app:assembleDebug -Ptarget="$(FLUTTER_INTEGRATION_TEST_DART_FILE)"

clean_and_install_dependencies:
	flutter clean \
	&& flutter packages get

build: build-android-apk-files build-ios-ipa-files

.DEFAULT_GOAL := build
