import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prototipo_movil_proyecto/users/screens/login_screen.dart';

void main() {
  testWidgets('Login', (WidgetTester tester) async {
    final addFieldUser = find.byKey(const ValueKey('user'));
    final addFieldPassword = find.byKey(const ValueKey('password'));
    final addButton = find.byKey(const ValueKey('login'));

    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    await tester.enterText(addFieldUser, "prueba");
    await tester.enterText(addFieldPassword, "prueba");
    await tester.tap(addButton);
    await tester.pump();

    expect(find.text('Usuario y/o contraseña incorrectos'), findsOneWidget);
  });
}
