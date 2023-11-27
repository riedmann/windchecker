// ignore: file_names
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:windchecker/spot_list.dart';

class SpotScreen extends StatefulWidget {
  const SpotScreen({super.key});

  @override
  _SpotScreenState createState() => _SpotScreenState();
}

class _SpotScreenState extends State<SpotScreen> {
  bool isSummer = true;

  @override
  void initState() {
    super.initState();
    readSeason();
  }

  readSeason() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isSummer = prefs.getBool("isSummer") ?? false;
    });
  }

  setSeason(bool isSummer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isSummer", isSummer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff43AA8B),
      appBar: AppBar(
        backgroundColor: const Color(0xff346F5D),
        title: const Text("Wind & Snowchecker"),
        actions: [
          Row(
            children: [
              isSummer ? const Text("Summer") : const Text("Winter"),
              Switch(
                  activeColor: Colors.white,
                  value: isSummer,
                  onChanged: (value) {
                    setState(() {
                      isSummer = value;
                    });
                    setSeason(isSummer);
                  })
            ],
          )
        ],
      ),
      body: SpotList(isSummer: isSummer),
    );
  }
}
