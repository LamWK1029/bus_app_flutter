import 'dart:async';

import 'package:flutter/material.dart';
import '../apiCaller/bus_routes.dart';
import '../apiCaller/bus_stops.dart';
import '../apiCaller/bus_stop_arrival.dart';
import 'package:flutter_beep/flutter_beep.dart';

class BusScreen extends StatefulWidget {
  const BusScreen({super.key});

  @override
  State<BusScreen> createState() => _BusScreenState();
}

class _BusScreenState extends State<BusScreen> {
  Timer? timer;
  late BusRoute targetBus;
  List<BusStopItem> _targetBusStop = [];

  @override
  void initState() {
    timer = Timer.periodic(const Duration(minutes: 1),
        (Timer t) => checkExpandedStopsArrivedTime(soundEnable: true));
    super.initState();
  }

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
            targetBus = targetBusByPass;
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
        setState(() {
          _targetBusStop[index].isExpanded = !isExpanded;
        });
        checkExpandedStopsArrivedTime(soundEnable: false);
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

  void checkExpandedStopsArrivedTime({required bool soundEnable}) {
    for (var busStop in _targetBusStop) {
      if (busStop.isExpanded) {
        getBusArivedTime(
                rusRoute: targetBus.route,
                busBound: targetBus.bound,
                busStopID: busStop.busStop.stop)
            .then((arrivedTimeList) {
          String busArrivedTimeList = "到站時間: ";
          for (var arrivedTime in arrivedTimeList) {
            if (arrivedTime.remainningTime == 10 && soundEnable) {
              FlutterBeep.beep();
            }
            (arrivedTime.remainningTime > 0)
                ? busArrivedTimeList +=
                    "\n ${arrivedTime.remainningTime.toString().padLeft(2, '  ')} 分鐘"
                : busArrivedTimeList += "\n  -- 到達";
          }
          setState(() {
            busStop.expandedValue = busArrivedTimeList;
          });
        });
      }
    }
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
      expandedValue: '未有班次',
    );
  });
}
