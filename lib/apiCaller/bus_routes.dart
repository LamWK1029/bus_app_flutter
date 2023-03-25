import 'api_caller.dart';

class BusRoute {
  late String co, route, bound, origEn, origTc, origSc, destEn, destTc, destSc;

  BusRoute(
      {this.co = "",
      this.route = "",
      this.origEn = "",
      this.origTc = "",
      this.origSc = "",
      this.destEn = "",
      this.destTc = "",
      this.destSc = ""});
}

// create a class for bus stop with only route, orig_en, and dest_en
class BusStopForRepeatCheck {
  late String route, origEn, destEn;
  BusStopForRepeatCheck({this.route = "", this.origEn = "", this.destEn = ""});

  @override
  bool operator ==(other) {
    return (other is BusStopForRepeatCheck) &&
        other.route == route &&
        other.origEn == origEn &&
        other.destEn == destEn;
  }
}

//Functions
Future<List<BusRoute>> getKMBBusRoutesList() async {
  List<BusRoute> busRoutesList = [];
  // KMB
  var url = Uri.https('data.etabus.gov.hk', '/v1/transport/kmb/route/');
  var busRoutes = await getApiData(url);

  List<BusStopForRepeatCheck> busRoutesListForRepeatCheck = [];
  for (var busRoute in busRoutes) {
    // use busRoute to create a BusStopForRepeatCheck object
    var busRouteForRepeatCheck = BusStopForRepeatCheck(
      route: busRoute['route'],
      origEn: busRoute['orig_en'],
      destEn: busRoute['dest_en'],
    );
    // add it to busRoutesListForRepeatCheck if it is not in the list
    if (!busRoutesListForRepeatCheck.contains(busRouteForRepeatCheck)) {
      busRoutesListForRepeatCheck.add(busRouteForRepeatCheck);
      var targetBus = BusRoute(
        co: "KMB",
        route: busRoute['route'],
        origEn: busRoute['orig_en'],
        origTc: busRoute['orig_tc'],
        origSc: busRoute['orig_sc'],
        destEn: busRoute['dest_en'],
        destTc: busRoute['dest_tc'],
        destSc: busRoute['dest_sc'],
      );
      targetBus.bound = busRoute['bound'];
      busRoutesList.add(targetBus);
    }
  }
  return busRoutesList;
}

Future<List<BusRoute>> getNWFBBusRoutesList() async {
  List<BusRoute> busRoutesList = [];
  // NWFB
  var url =
      Uri.https('rt.data.gov.hk', '/v1/transport/citybus-nwfb/route/NWFB');
  var busRoutes = await getApiData(url);
  for (var busRoad in busRoutes) {
    var targetBus = BusRoute(
      co: "NWFB",
      route: busRoad['route'],
      origEn: busRoad['orig_en'],
      origTc: busRoad['orig_tc'],
      origSc: busRoad['orig_sc'],
      destEn: busRoad['dest_en'],
      destTc: busRoad['dest_tc'],
      destSc: busRoad['dest_sc'],
    );
    busRoutesList.add(targetBus);
  }
  return busRoutesList;
}

Future<List<BusRoute>> getCTBBusRoutesList() async {
  List<BusRoute> busRoutesList = [];
  // call api to get routes
  var url = Uri.https('rt.data.gov.hk', '/v1/transport/citybus-nwfb/route/ctb');
  var busRoutes = await getApiData(url);
  for (var busRoad in busRoutes) {
    var targetBus = BusRoute(
      co: "ctb",
      route: busRoad['route'],
      origEn: busRoad['orig_en'],
      origTc: busRoad['orig_tc'],
      origSc: busRoad['orig_sc'],
      destEn: busRoad['dest_en'],
      destTc: busRoad['dest_tc'],
      destSc: busRoad['dest_sc'],
    );
    busRoutesList.add(targetBus);
  }
  return busRoutesList;
}

searchBus(
    {required String targetRoute, required List<BusRoute> busRoutesList}) {
  List<BusRoute> targetList = [];
  for (var routeInList in busRoutesList) {
    String searchRoute = routeInList.route;
    if (searchRoute.contains(targetRoute)) {
      targetList.add(routeInList);
    }
  }
  return targetList.toSet().toList();
}
