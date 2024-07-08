import 'package:appium_flutter_server/appium_flutter_server.dart';
import 'package:saucelabs_flutter_counter_demo_app/app.dart';

void main() {
  initializeTest(app: const CounterApp());
}