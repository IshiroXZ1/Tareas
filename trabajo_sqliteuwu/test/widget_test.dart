import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:trabajo_sqliteuwu/screens/home_screen.dart';

void main() {
  testWidgets('Muestra la pantalla de estudiantes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.text('Gestión de Estudiantes'), findsOneWidget);
  });
}
