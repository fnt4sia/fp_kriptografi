import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fp_kriptografi/routes/routes.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kriptografi Application',
      theme: ThemeData(
        useMaterial3: true,
      ),
      getPages: AppRoutes.routes,
      initialRoute: '/splash',
      debugShowCheckedModeBanner: false,
    );
  }
}
