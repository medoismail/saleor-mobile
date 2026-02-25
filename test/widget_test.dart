import 'package:flutter_test/flutter_test.dart';

import 'package:saleor_mobile/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SaleorApp());
    // Basic smoke test - app renders without crashing
    expect(find.text('Saleor Store'), findsOneWidget);
  });
}
