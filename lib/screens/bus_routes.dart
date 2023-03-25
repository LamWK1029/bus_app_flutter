import 'package:flutter/material.dart';
import '../apiCaller/bus_routes.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  List<BusRoute> allBusRoutes = [];
  List<BusCard> displayBusRoutes = [];

  void showRoutes({required bool withKeyword, String keyword = ""}) {
    List<BusCard> fitRoutes = [];
    for (var busRoute in allBusRoutes) {
      if (withKeyword && busRoute.route.contains(keyword)) {
        fitRoutes.add(BusCard(busRote: busRoute));
      } else if (!withKeyword) {
        fitRoutes.add(BusCard(busRote: busRoute));
      }
    }
    setState(() {
      displayBusRoutes = fitRoutes;
    });
  }

  @override
  void initState() {
    getKMBBusRoutesList().then((apiData) {
      allBusRoutes = apiData;
      showRoutes(withKeyword: false);
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
              controller: _controller,
              onChanged: (inputText) {
                showRoutes(withKeyword: true, keyword: inputText);
              },
              onTap: () {
                _controller.clear();
                showRoutes(withKeyword: false);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a bus number for searching',
                suffixIcon: Icon(Icons.clear),
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
        children: [
          ListTile(
            leading: const Icon(Icons.directions_bus_sharp),
            title: Text(
              busRote.route,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${busRote.origTc} > ${busRote.destTc}'),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/BusScreen',
                arguments: busRote,
              );
            },
          ),
        ],
      ),
    );
  }
}
