import 'package:flutter/material.dart';
import 'package:selektion/routes.dart';
import 'package:selektion/services/local_player_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalDatabaseService.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Selektion',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
