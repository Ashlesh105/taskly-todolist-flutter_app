import 'package:flutter/material.dart';
import 'package:taskly_app/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
await Hive.initFlutter("hive_boxes"); //Hive is a nosql db and it stores values in key-value pair like maps.
                                  // Hive creates databases and stores data in them called boxes (directory)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taskly',
      theme: ThemeData(primarySwatch: Colors.red),
      home: HomePage(),
    );
  }
}
