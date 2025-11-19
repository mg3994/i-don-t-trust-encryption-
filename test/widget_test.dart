import 'package:flutter_test/flutter_test.dart';
import 'package:signal/main.dart';

void main() {
  testWidgets('App renders feed and navigates to profile', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('LinkWithMentor'), findsOneWidget);
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('John Doe'), findsOneWidget);
  });
}
