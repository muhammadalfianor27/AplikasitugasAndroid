import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'Detail.dart';
import 'AddData.dart';


void main(){
  runApp(new MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List> getData() async {
    final response = await http.get("http://10.0.3.2/pegawai/GetPegawai.php");
    return json.decode(response.body);
  }

  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: new AppBar(
          title: Text("Data Pegawai"),
          backgroundColor: Colors.blue,
        ),
        floatingActionButton: new FloatingActionButton(
          child: new Icon(
            Icons.add,
            color: Colors.blue,
          ),
          onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => new AddData(),
          )),
        ),

        body: new FutureBuilder<List>(
          future: getData(),
          builder: (context, snapshot){
            if(snapshot.hasError) print(snapshot.error);
            return snapshot.hasData ? new ItemList(
              list: snapshot.data,
            ) : new Center(child: new CircularProgressIndicator()
            ,);
          },
        ),
      ),
    );
  }
}

class ItemList extends StatelessWidget {

  final List list;
  ItemList({this.list});

  Widget build(BuildContext context){
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i){
        return new Container(
          child: new GestureDetector(
            onTap: () => Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new Detail(
                list: list,
                index: i,
              )
            )),

            child: new Card(
              color: Colors.blue,
              child: new ListTile(
                title: new Text(list[i]['nama']),
                leading: new Icon(Icons.list),
                subtitle: new Text("Posisi : ${list[i] ['posisi']}"),
              ),
            ),
          ),
        );
      }
    );
  }
}