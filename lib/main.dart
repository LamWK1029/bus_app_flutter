import 'package:flutter/material.dart';
import 'screens/search.dart';
import 'apiCaller/bus_routes.dart';
import 'apiCaller/bus_stops.dart';
import 'apiCaller/bus_stop_arrival.dart';

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
  String targetBus = "";
  List<BusStopItem> _targetBusStop = [];

  @override
  Widget build(BuildContext context) {
    final targetBusByPass =
        ModalRoute.of(context)!.settings.arguments as BusRoute;

    getKMBBusStopsMap().then((allStops) {
      searchStopsByRoutes(
        busStopsMap: allStops,
        route: targetBusByPass.route,
        bound: targetBusByPass.bound,
      ).then((targetBusStops) {
        if (_targetBusStop.isEmpty) {
          setState(() {
            targetBus = targetBusByPass.route;
            _targetBusStop = generateBusStopItem(targetBusStops);
          });
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("${targetBusByPass.route} 住${targetBusByPass.destTc}"),
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
        if (!_targetBusStop[index].isExpanded) {
          getBusArivedTime(
                  rusRoute: targetBus,
                  busStopID: _targetBusStop[index].busStop.stop)
              .then((arrivedTimeList) {
            String busArrivedTimeList = "到站時間: ";
            for (var arrivedTime in arrivedTimeList) {
              if (arrivedTime.remainningTime > 0) {
                busArrivedTimeList +=
                    "\n ${arrivedTime.remainningTime.toString().padLeft(2, '  ')} 分鐘";
              } else {
                busArrivedTimeList += "\n 到達";
              }
            }
            setState(() {
              _targetBusStop[index].isExpanded = !isExpanded;
              _targetBusStop[index].expandedValue = busArrivedTimeList;
            });
          });
        } else {
          setState(() {
            _targetBusStop[index].isExpanded = !isExpanded;
          });
        }
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
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}

// bus stop
class BusStopItem {
  BusStopItem({
    required this.busStop,
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  BusStop busStop;
  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<BusStopItem> generateBusStopItem(List<BusStop> targetBusStops) {
  return List<BusStopItem>.generate(targetBusStops.length, (int index) {
    return BusStopItem(
      busStop: targetBusStops[index],
      headerValue: "${index + 1}. ${targetBusStops[index].nameTc}",
      expandedValue: '到站時間: ',
    );
  });
}
