import 'package:flutter_test/flutter_test.dart';
import 'package:projet_flutter_bordas/main.dart';

void main() {
  testWidgets('HomeScreen shows title and camera button', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Projeto Bordas'), findsOneWidget);
    expect(find.text('Abrir Câmera'), findsOneWidget);
  });
}
