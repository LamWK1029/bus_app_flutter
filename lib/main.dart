import 'package:flutter/material.dart';
import 'screens/search.dart';
import 'apiCaller/bus_routes.dart';
import 'apiCaller/bus_stops.dart';

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

//BusScreen
class BusScreen extends StatefulWidget {
  const BusScreen({super.key});

  @override
  State<BusScreen> createState() => _BusScreenState();
}

class _BusScreenState extends State<BusScreen> {
  List<BusStopItem> _targetBusStop = [];

  @override
  Widget build(BuildContext context) {
    final targetBus = ModalRoute.of(context)!.settings.arguments as BusRoute;

    getKMBBusStopsMap().then((allStops) {
      searchStopsByRoutes(
        busStopsMap: allStops,
        route: targetBus.route,
        bound: targetBus.bound,
      ).then((targetBusStops) {
        setState(() {
          _targetBusStop = generateBusStopItem(targetBusStops);
        });
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("${targetBus.route} 住${targetBus.destTc}"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: _buildPanel(),
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _targetBusStop[index].isExpanded = !isExpanded;
        });
      },
      children: _targetBusStop.map<ExpansionPanel>((BusStopItem item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: ListTile(
              title: Text(item.expandedValue),
              subtitle:
                  const Text('To delete this panel, tap the trash can icon'),
              trailing: const Icon(Icons.delete),
              onTap: () {
                setState(() {});
              }),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}

// bus stop
class BusStopItem {
  BusStopItem({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<BusStopItem> generateBusStopItem(List<BusStop> targetBusStops) {
  return List<BusStopItem>.generate(targetBusStops.length, (int index) {
    return BusStopItem(
      headerValue: targetBusStops[index].nameTc,
      expandedValue: 'This is item number $index',
    );
  });
}
