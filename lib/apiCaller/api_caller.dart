import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

getApiData(Uri apiURL) async {
  bool deviceOnline = await InternetConnectionChecker().hasConnection;
  if (deviceOnline) {
    var response = await http.get(apiURL);
    if (response.statusCode == 200) {
      var busRoadsInJSON = jsonDecode(response.body);
      return busRoadsInJSON['data'];
    }
  }
  return {};
}
