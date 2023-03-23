import 'api_caller.dart';

class BusStopArrival {
  late String route, dir, destTc, destSc, destEn, eta, rmkTc, rmkSc, rmkEn;
  late int remainningTime;

  BusStopArrival(
      {this.route = "",
      this.dir = "",
      this.destTc = "",
      this.destSc = "",
      this.destEn = "",
      this.eta = "",
      this.rmkTc = "",
      this.rmkSc = "",
      this.rmkEn = "",
      this.remainningTime = -1});
}

getBusArivedTime(
    {required String rusRoute,
    required String busBound,
    required String busStopID}) async {
  List<BusStopArrival> arrivalList = [];

  var url =
      Uri.https('data.etabus.gov.hk', '/v1/transport/kmb/stop-eta/$busStopID');

  var busShiftInfos = await getApiData(url);
  for (var busShift in busShiftInfos) {
    if (rusRoute == busShift['route'] && busBound == busShift['dir']) {
      // check remainning arrvial time
      var now = DateTime.now();
      var parsedDate = DateTime.parse(busShift['eta'].toString());

      arrivalList.add(BusStopArrival(
          route: busShift['route'],
          dir: busShift['dir'],
          destTc: busShift['dest_tc'],
          destSc: busShift['dest_sc'],
          eta: busShift['eta'],
          rmkTc: busShift['rmk_tc'],
          rmkSc: busShift['rmk_sc'],
          rmkEn: busShift['rmk_en'],
          remainningTime: parsedDate.difference(now).inMinutes));
    }
  }
  return arrivalList;
}
