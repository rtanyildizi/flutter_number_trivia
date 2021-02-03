import 'package:flutter/material.dart';

import 'features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'features/number_trivia/presentation/predefined_values/colors/colors.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Number Trivia App',
      theme: ThemeData(
        primaryColor: triviaPurple,
        accentColor: Colors.blue.shade600,
      ),
      home: NumberTriviaPage(),
    );
  }
}
