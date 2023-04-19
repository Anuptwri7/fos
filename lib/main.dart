import 'package:flutter/material.dart';
import 'package:fos/auth/loginScreen.dart';

import 'consts/string_const.dart';

void main() {
  runApp( MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "FOS",
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            // textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
          ),
          home: LoginScreen());

  }

}
