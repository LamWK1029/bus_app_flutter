import 'package:flutter/material.dart';
import 'screens/search.dart';
import '../apiCaller/bus_routes.dart';

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

class BusScreen extends StatelessWidget {
  const BusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final targetBus = ModalRoute.of(context)!.settings.arguments as BusRoute;

    return Scaffold(
      appBar: AppBar(
        title: Text("${targetBus.route} 住${targetBus.destTc}"),
        backgroundColor: Colors.black,
      ),
    );
  }
}
