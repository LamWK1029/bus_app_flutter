import 'package:flutter/material.dart';
import 'apiCaller/bus_routes.dart';

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

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<BusRoute> allBusRoutes = [];
  List<BusCard> displayBusRoutes = [];

  @override
  void initState() {
    getKMBBusRoutesList().then((apiData) {
      setState(() {
        allBusRoutes = apiData;
        List<BusCard> fitRoutes = [];
        for (var busRoute in allBusRoutes) {
          fitRoutes.add(BusCard(busRote: busRoute));
        }
        displayBusRoutes = fitRoutes;
      });
    });
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
              onChanged: (inputText) {
                setState(() {
                  if (allBusRoutes.isNotEmpty) {
                    List<BusCard> fitRoutes = [];
                    for (var busRoute in allBusRoutes) {
                      if (busRoute.route.contains(inputText)) {
                        fitRoutes.add(BusCard(busRote: busRoute));
                      }
                    }
                    displayBusRoutes = fitRoutes;
                  }
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
                padding: const EdgeInsets.all(8), children: displayBusRoutes),
          ),
        ],
      ),
    );
  }
}

class BusCard extends StatelessWidget {
  final BusRoute busRote;

  const BusCard({super.key, required this.busRote});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.directions_bus_sharp),
            title: Text(busRote.route),
            subtitle: Text('${busRote.origTc} -> ${busRote.destTc}'),
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
