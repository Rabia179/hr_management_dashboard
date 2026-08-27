import 'package:flutter_test/flutter_test.dart';
import 'package:hr_management_dashboard/main.dart';

void main() {
  testWidgets('HR Management Dashboard loads', (tester) async {
    await tester.pumpWidget(
      const HRManagementApp(),
    );

    expect(
      find.text('Dashboard'),
      findsOneWidget,
    );
  });
}