import 'package:flutter/material.dart';
import 'screens/search.dart';
import 'screens/target.dart';

void main() {
  runApp(MaterialApp(
    title: "Bus App",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    initialRoute: "/",
    routes: {
      "/": (context) => const SearchScreen(),
      '/BusScreen': (context) => const BusScreen(),
    },
  ));
}
