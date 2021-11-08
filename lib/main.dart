import 'package:currency_converter/services/api_client.dart';
import 'package:currency_converter/widgets/drop_down.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiClient client = ApiClient();
  //Setting the main colors
  Color mainColor = Colors.blueGrey[900];
  //Setting the Variable
  List<String> currencies;
  String from;
  String to;

  //variable for exchange rate
  double rate;
  String result = "";

  Future<List<String>> getCurrencyList() async {
    return await client.getCurrencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    (() async {
      List<String> list = await client.getCurrencies();
      setState(() {
        currencies = list;
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mainColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 400.0,
                  child: Text(
                    "CURRENCY CONVERTER",
                    style: TextStyle(
                      color: Colors.lightBlue[50],
                      fontSize: 34,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //set the text field
                        TextField(
                          onSubmitted: (value) async{
                          rate = await client.getRate(from, to);
                          setState(() {
                            result= (rate * double.parse(value)).toStringAsFixed(3);
                          });
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Input The Value",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.blueGrey,
                              fontSize: 20.0,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //custom widget for currencies drop down
                            customDropDown(currencies, from, (val) {
                              setState(() {
                                from = val;
                              });
                            }),
                            FloatingActionButton(
                              onPressed: () {
                                String temp = from;
                                setState(() {
                                  from = to;
                                  to = temp;
                                });
                              },
                              child: Icon(Icons.swap_horiz),
                              elevation: 0.0,
                              backgroundColor: Colors.blueGrey[400],
                            ),
                            customDropDown(currencies, to, (val) {
                              setState(() {
                                to = val;
                              });
                            }),
                          ],
                        ),
                        SizedBox(height:50.0),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Column(
                            children: [
                              Text("Result", style: TextStyle(
                                color: Colors.black,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              )),
                              Text(result, style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 36.0,
                                fontWeight: FontWeight.bold,
                              )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
