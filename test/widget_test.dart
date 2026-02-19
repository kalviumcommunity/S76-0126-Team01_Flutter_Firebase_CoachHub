import 'package:flutter_test/flutter_test.dart';

import 'package:s76_0126_team01_flutter_firebase_coachhub/main.dart';

void main() {
  testWidgets('App loads login page', (WidgetTester tester) async {
    await tester.pumpWidget(const CoachubApp());

    expect(find.text('Welcome Back'), findsOneWidget);
  });
}
