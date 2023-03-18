import 'package:flutter/material.dart';
import 'apiCaller/bus_routes.dart';

void main() {
  runApp(MaterialApp(
    title: "Bus App",
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

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String busSearchInput = "";

  @override
  void initState() {
    var busRoutesList = getKMBBusRoutesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bus App"),
        backgroundColor: Colors.black,
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  busSearchInput = text;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a bus number for searching',
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                BusCard(busRotes: busSearchInput),
                BusCard(busRotes: busSearchInput),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BusCard extends StatelessWidget {
  final String busRotes;

  const BusCard({super.key, required this.busRotes});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.bus_alert_rounded),
            title: Text(busRotes),
            subtitle: const Text('FU NING to CU'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text('Check Time'),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}

class BusScreen extends StatelessWidget {
  const BusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
