import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
// Add as app because we want to make sure the app loaded correctly on the device by calling the main function in the main dart file.
import 'package:my_demo_app_flutter/main.dart' as app;
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
      /**
       * import 'package:flutter/material.dart';
       * We can use the enterText to write test on elements on the screen.
       * This function takes 2 elements a finder and String to be written
       *
       * finder examples :
       *      find.byType(TextFormField).at(0)
       *      find.byKey(const Key("test"))
       */

      // Click the increment button 5 times
      const incKey = Key('counterView_increment_floatingActionButton');
      for (var i = 0; i < 5; i++) {
        await Future.delayed(const Duration(seconds: 1));
        await tester.tap(find.byKey(incKey));
        await tester.pump(); // Rebuild the widget after each tap.
      }

      // Click the decrement button 3 times
      const decKey = Key('counterView_decrement_floatingActionButton');
      for (var i = 0; i < 3; i++) {
        await Future.delayed(const Duration(seconds: 1));
        await tester.tap(find.byKey(decKey));
        await tester.pump(); // Rebuild the widget after each tap.
      }

      await Future.delayed(const Duration(seconds: 2));
      // Verify the Text shown is 2
      const counterValueKey = Key('textView_counterValue_Text');
      expect(find.byKey(counterValueKey), findsOneWidget);

      // Retrieve the Text widget and verify its content.
      final textWidget = tester.widget<Text>(find.byKey(counterValueKey));
      expect(textWidget.data, '2');
    });
  });
}