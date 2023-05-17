import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../main.dart';


//  hive with theme 
class ThemePage extends StatelessWidget {
  const ThemePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var box = Hive.box("theme");

    return Scaffold(
      appBar: AppBar(),
    );
  }
}
