import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_demo_app_flutter/main.dart' as app; // Ensure this path is correct

void main() {
  final IntegrationTestWidgetsFlutterBinding binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Counter App Integration Test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    app.main();
    
    await tester.pumpAndSettle();
    // Click the increment button 5 times.
    const incKey = Key('counterView_increment_floatingActionButton'); 
    for (var i = 0; i < 5; i++) {
      await Future.delayed(const Duration(seconds: 1));
      await tester.tap(find.byKey(incKey));
      await tester.pump(); // Rebuild the widget after each tap.
    }

    // Click the decrement button 3 times.
    const decKey = Key('counterView_decrement_floatingActionButton'); 
    for (var i = 0; i < 3; i++) {
      await Future.delayed(const Duration(seconds: 1));
      await tester.tap(find.byKey(decKey));
      await tester.pump(); // Rebuild the widget after each tap.
    }

    await Future.delayed(const Duration(seconds: 2));
    
    // Verify the Text shown is 2.
    const counterValueKey = Key('textView_counterValue_Text'); 
    expect(find.byKey(counterValueKey), findsOneWidget);
    
    // Retrieve the Text widget and verify its content.
    final textWidget = tester.widget<Text>(find.byKey(counterValueKey));
    expect(textWidget.data, '2');
  });
}
