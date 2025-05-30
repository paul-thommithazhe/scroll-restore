import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scroll_restore/src/scroll_restore.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('ScrollRestore restores saved offset on init', (WidgetTester tester) async {
    // 1) Mock a saved offset of 100.0 pixels
    SharedPreferences.setMockInitialValues({'test-list': 100.0});

    // 2) Variable to capture the controller from inside the builder
    ScrollController? capturedController;

    // 3) Build the ScrollRestore widget
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ScrollRestore(
          id: 'test-list',
          builder: (context, controller) {
            // capture it for later inspection
            capturedController = controller;
            return ListView(
              controller: controller,
              children: List.generate(
                20,
                (i) => SizedBox(height: 50, child: Text('Item $i')),
              ),
            );
          },
        ),
      ),
    );

    // 4) Allow initState and our postFrameCallback to run
    await tester.pump();                       // kicks off initState()
    await tester.pump(const Duration(milliseconds: 100)); 
    await tester.pumpAndSettle();              // waits for any remaining frames

    // 5) Now assert the controller offset
    expect(capturedController, isNotNull);
    // It should be roughly 100.0 (clamped to maxScroll if your list shorter)
    expect(capturedController!.offset, closeTo(100.0, 0.1));
  });
}
