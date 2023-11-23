import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'vo/spot.dart';

class SpotList extends StatefulWidget {
  final bool isSummer;
  const SpotList({required this.isSummer, Key? key}) : super(key: key);

  @override
  SpotListState createState() => SpotListState();
}

class SpotListState extends State<SpotList> {
  List<Widget> spots = [];

  @override
  void initState() {
    super.initState();
    loadSpots();
  }

  void loadSpots() async {
    List<Widget> widgets = [];
    var response = await http.get(
        Uri.parse(
            "https://api.riedmann.rocks/windchecker/items/spots?fields=*.*.*&status=published&sort=name"),
        headers: {"Accept": "application/json"});

    var dataOrig = json.decode(response.body)["data"];
    for (var el in dataOrig) {
      Spot s = Spot.fromJson(el);
      if (s.isSummer == widget.isSummer) {
        widgets.add(InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/items', arguments: s);
          },
          child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffD4CECE), width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        s.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 20),
                      )),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        s.description,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w100,
                            fontSize: 15),
                      ))
                ],
              )),
        ));
      }
    }

    setState(() {
      spots = widgets;
    });
  }

  @override
  Widget build(BuildContext context) {
    loadSpots();
    return GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,
        childAspectRatio: 2,
        // Generate 100 widgets that display their index in the List.
        children: spots);
  }
}
