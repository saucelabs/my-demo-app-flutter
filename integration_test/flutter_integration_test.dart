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

    for (int testIndex = 1; testIndex <= 9; testIndex++) {
      testWidgets("Test $testIndex - Run for 1 minute+", (tester) async {
        app.main();
        await tester.pumpAndSettle(); // wait for app to be ready.
        const incKey = Key('counterView_increment_floatingActionButton');
        const decKey = Key('counterView_decrement_floatingActionButton');
        const timerKey = Key('textView_timer_Text');
        const counterKey = Key('textView_counterValue_Text');
        int counter = 0;

        // Click the increment button 5 times
        for (var i = 0; i < 5; i++) {
          await tester.tap(find.byKey(incKey));
          counter++;
          await rebuildTestWidgetAfterXSeconds(tester, 5);
        }

        // Click the decrement button 3 times
        for (var i = 0; i < 3; i++) {
          await tester.tap(find.byKey(decKey));
          counter--;
          await rebuildTestWidgetAfterXSeconds(tester, 5);
        }
        // Click the increment button 4 times
        for (var i = 0; i < 4; i++) {
          await tester.tap(find.byKey(incKey));
          counter++;
          await rebuildTestWidgetAfterXSeconds(tester, 5);
        }

        // Click the decrement button 4 times
        for (var i = 0; i < 4; i++) {
          await tester.tap(find.byKey(decKey));
          counter--;
          await rebuildTestWidgetAfterXSeconds(tester, 2);
        }
        // Click the increment button 2 times
        for (var i = 0; i < 2; i++) {
          await tester.tap(find.byKey(incKey));
          counter++;
          await rebuildTestWidgetAfterXSeconds(tester, 1);
        }

        await rebuildTestWidgetAfterXSeconds(tester, 2);
        // Verify the Text shown is 2
        expect(find.byKey(counterKey), findsOneWidget);

        // Retrieve the Text widget and verify its content.
        final textWidget = tester.widget<Text>(find.byKey(counterKey));
        expect(textWidget.data, counter.toString());

        // Verify that we have a timer visible on the screen.
        expect(find.byKey(timerKey), findsOneWidget);
      });
    }
  });
}

Future<void> rebuildTestWidgetAfterXSeconds(WidgetTester tester, int nbSec) async {
  for (var i = 0; i < nbSec; i++) {
    await tester.pump(); // Rebuild the widget after each tap.
    await Future.delayed(const Duration(seconds: 1));
  }
}