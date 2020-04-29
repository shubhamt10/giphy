import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giphy/networking.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String searchText;
  TextEditingController controller;
  List<String> gifs;

  @override
  void initState() {
    gifs = List<String>();
    super.initState();
  }

  void getData() async {
    Networking networking = Networking();
    try {
      var jsonData = await networking.getData(searchText);
      if (jsonData != null) {
        var data = jsonData['data'];
        gifs.clear();
        for (int i = 0; i < 20; i++) {
          var url = data[i]['images']['fixed_height']['url'];
          print(url.toString());
          setState(() {
            gifs.add(url.toString());
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.tealAccent[700],
          title: Text(
            'Giphy',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SafeArea(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: TextField(
                          controller: controller,
                          textAlign: TextAlign.center,
                          onChanged: (text) {
                            setState(() {
                              searchText = text;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search',
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: FlatButton(
                        child: Icon(CupertinoIcons.search),
                        onPressed: () {
                          getData();
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    scrollDirection: Axis.vertical,
                    children: List.generate(gifs.length, (index) {
                      return Container(
                        child: Card(
                          child: Image.network(gifs[index],
                              alignment: Alignment.center, loadingBuilder:
                                  (BuildContext context, Widget child,
                                      ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;

                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 6QTdm0lsVtOADxLdxuzNfFZCXTrdYU6u
