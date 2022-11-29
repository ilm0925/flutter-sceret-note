import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secret_note/passwordChange.dart';

import 'key.dart';
import 'login.dart';
import 'showRule.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: ((context) => KeyProvider()))],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/note': (context) => const MainPage(),
          '/passwordChange': (context) => const passwordChage(),
        },
        home: const Login(),
      ),
    );
  }
}