import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trabajo_sharedpreferences/main.dart';

void main() {
  testWidgets('Muestra el formulario de perfil', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

    expect(find.text('Mi Perfil'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Guardar'), findsOneWidget);
  });
}
