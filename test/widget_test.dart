import 'package:flutter_test/flutter_test.dart';
import 'package:forword_cricket/app.dart';

void main() {
  testWidgets('home screen renders the Forword Cricket navigation', (tester) async {
    await tester.pumpWidget(const ForwordCricketApp());
    expect(find.text('FORWORD'), findsOneWidget);
    expect(find.text('CRICKET'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Quiz'), findsOneWidget);
  });
}
