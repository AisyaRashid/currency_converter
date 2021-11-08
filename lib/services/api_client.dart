import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class ApiClient {
  final Uri currencyURL = Uri.https("freecurrencyapi.net", "/api/v2/latest",
      {"apiKey": "ed52df20-3bf8-11ec-ba65-2b5055719b5e"});

  Future<List<String>> getCurrencies() async {
    http.Response res = await http.get(currencyURL);
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      var list = body["results"];
      List<String> currencies = (list.keys).toList();
      print(currencies);
      return currencies;
    } else {
      throw Exception("Failed to connect to API");
    }
  }

  Future<double> getRate(String from, String to) async {
    final Uri rateUrl = Uri.https('freecurrencyapi.net', '/api/v2/latest', {
      "apiKey": "ed52df20-3bf8-11ec-ba65-2b5055719b5e",
      "q": "${from}_${to}",
      "compact": "ultra"
    });
    http.Response res = await http.get(rateUrl);
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      return body["${from}_${to}"];
    } else {
      throw Exception("Failed to connect to API");
    }
  }
}
