import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:localdata_with_hive/view/my_home_page.dart';
import 'package:localdata_with_hive/view/splash.dart';

 bool darkMode  = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("BoxTest");
  await Hive.openBox("theme");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('theme').listenable(),
      builder: (context, box, widget) {
        var darkMode = box.get('darkMode', defaultValue: false);
        return MaterialApp(
          title: 'Hive Demo',
          debugShowCheckedModeBanner: false,
          themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData(
            // colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            textTheme: const TextTheme(
              labelMedium: TextStyle(color: Colors.white)
            ),
            listTileTheme: const ListTileThemeData(tileColor: Colors.white,textColor: Colors.deepPurple),
            scaffoldBackgroundColor: Colors.black,
            useMaterial3: true,
          ),
          theme: ThemeData(
            textTheme: const TextTheme(
                labelMedium: TextStyle(color: Colors.deepPurple)
            ),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            listTileTheme: const ListTileThemeData(tileColor: Colors.deepPurple,textColor: Colors.white),
            scaffoldBackgroundColor: Colors.white,
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
