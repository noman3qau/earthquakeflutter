import 'package:flutter/material.dart';
import 'package:jsonparsing/global.dart';
import 'package:jsonparsing/models/weatherapi.dart';
import 'package:jsonparsing/utilities/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Home extends StatefulWidget {
  String title;

  Home({this.title});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  WhetherApi whetherApi;

  List<Color> colors = [
    Colors.yellow,
    Colors.greenAccent,
    Colors.red,
    Colors.purple,
    Colors.blue
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Center(
                child: new Text(widget.title),
              ),
            ),
            body: Container(
              color: greyColor,
              child: FutureBuilder(
                future: fetchPosts(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.data ==
                      "Sorry for inconvience, Server is under mantinance.") {
                    return Container(
                      child: Text(snapshot.data),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: whetherApi.features.length,
                      itemBuilder: (BuildContext context, index) {
                        List<String> place = whetherApi
                            .features[index].properties.place
                            .split(",");
                        return Container(
                          padding: EdgeInsets.all(8.0),
                          margin:
                              EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              shape: BoxShape.rectangle,
                              color: Colors.white),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 6,
                                child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: colors[whetherApi.features[index].properties.mag.ceil()>4?4:whetherApi.features[index].properties.mag.ceil()]
                                        ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        (whetherApi
                                            .features[index].properties.mag
                                            .ceil()
                                            .toString()),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    place[place.length - 1].trim(),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    place[0].toString(),
                                    style: TextStyle(fontSize: 14),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            )));
  }

  fetchPosts() async {
    var response = await http
        .get(EARTHQUAKE_URL, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      print(response.body);

      var jsonData = json.decode(response.body);
      whetherApi = WhetherApi.fromJson(jsonData);

      return whetherApi;
    } else {
      print("Error");
      return "Sorry for inconvience, Server is under mantinance.";
    }
  }
}
