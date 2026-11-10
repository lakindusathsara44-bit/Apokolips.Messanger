import 'package:flutter_test/flutter_test.dart';
import 'package:apokolips_messenger/app.dart';

void main() {
  testWidgets('shows backend setup guidance when Supabase is not configured',
      (tester) async {
    await tester.pumpWidget(
      const ApokolipsMessengerApp(supabaseConfigured: false),
    );

    expect(find.text('Connect your backend'), findsOneWidget);
    expect(find.textContaining('SUPABASE_URL'), findsOneWidget);
  });
}
