import 'api_caller.dart';

class BusStop {
  late String stop, nameEn, nameTc, nameSc, lat, long;

  BusStop(
      {this.stop = "",
      this.nameEn = "",
      this.nameTc = "",
      this.nameSc = "",
      this.lat = "",
      this.long = ""});
}

//Functions
getKMBBusStopsMap() async {
  Map<String, BusStop> busStopsMap = {};

  var url = Uri.https('data.etabus.gov.hk', '/v1/transport/kmb/stop');
  var busStops = await getApiData(url);
  for (var busStop in busStops) {
    busStopsMap[busStop['stop']] = BusStop(
      stop: busStop['stop'],
      nameEn: busStop['name_en'],
      nameTc: busStop['name_tc'],
      nameSc: busStop['name_sc'],
      lat: busStop['lat'],
      long: busStop['long'],
    );
  }
  return busStopsMap;
}

searchStopsByRoutes(
    {required Map busStopsMap,
    required String route,
    required String bound}) async {
  List<BusStop> targetBusStopList = [];

  var url = (bound == 'I')
      ? Uri.https(
          'data.etabus.gov.hk', '/v1/transport/kmb/route-stop/$route/inbound/1')
      : Uri.https('data.etabus.gov.hk',
          '/v1/transport/kmb/route-stop/$route/outbound/1');
  var busStops = await getApiData(url);
  for (var busStop in busStops) {
    var targetStop = busStopsMap[busStop['stop']];
    targetBusStopList.add(targetStop);
  }
  return targetBusStopList;
}
