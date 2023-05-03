import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country Information',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const CountryPage(title: 'Country Search'),
    );
  }
}


class CountryPage extends StatefulWidget {
  const CountryPage({Key? key, required String title}) : super(key: key);

  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage>{
  late String _countryCode;
  late Map<String, dynamic> _countryData;
  late String _flagUrl;

  @override
  void initState() { 
    super.initState();
    _countryCode = '';
    _countryData = {};
    _flagUrl = '';

  }


Future<void> _getCountryData() async{
  var apiKey = '26ve3KMY+StBMjmWxRwSuQ==ibdnRATMIkQ3S9M6';
  var url = 'https://api.api-ninjas.com/v1/country?/$_countryCode';
  var response = await http.get(Uri.parse(url), headers: {'apikey': apiKey});

  if (response.statusCode == 200){
    setState(() {
      _countryData = jsonDecode(response.body);
      _flagUrl = 'https://www.flagsapi.com/${_countryData['alpha2Code'].toLowerCase()}.png';

    });
  }else{
    setState(() {
      _countryData = {};
      _flagUrl = '';
    });
  }
}

@override
  Widget build(BuildContext context){
  return Scaffold(
    appBar: AppBar(
      title: const Text('Country Information'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Enter a country code (e.g. US)',
            ),
            onChanged: (value){
              setState(() {
                _countryCode = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: _getCountryData, 
            child: const Text('Search')
            ),
          if (_countryData.isNotEmpty)
            Padding(padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: Image.network(
                    _flagUrl,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent?loadingProgress){
                      if (loadingProgress == null){
                        return child;
                      }
                      return const CircularProgressIndicator();
                    },
                    errorBuilder: (BuildContext context, Object exeptio, StackTrace? stackTrace){
                      return const Text('Failed to load flag image');
                    },
                  ),
                ),
                 const SizedBox(height: 16.0),
                 Text(
                  'Country: ${_countryData['name']}',
                  style: const TextStyle(fontSize: 18.0),
                 ),
                 const SizedBox(height: 8.0),
                 Text(
                  'Captital: ${_countryData['capital']}',
                  style: const TextStyle(fontSize: 18.0),
                 ),
                 const SizedBox(height: 8.0),
                 Text(
                  'Population: ${_countryData['population']}',
                  style: const TextStyle(fontSize: 18.0),
                 ),
                 const SizedBox(height: 8.0),
                 Text(
                  'Region: ${_countryData['region']}',
                  style: const TextStyle(fontSize: 18.0),
                 ),
              ],
            ),
          )
        ],
      ),
    ),
  );
 }
}