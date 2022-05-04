// ignore_for_file: unused_element, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskermsc/Screens/search.dart';
import 'package:url_launcher/url_launcher.dart';

class chat extends StatefulWidget {
  const chat({Key? key}) : super(key: key);

  @override
  State<chat> createState() => _chatState();
}

class _chatState extends State<chat> {
  final _auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  List<String> users = [];
  List<String> pno = [];
  List<String> desig = [];
  List<String> purl = [];
  String uid = "";
  String url = "";
  @override
  void initState() {
    super.initState();
    firestoreInstance.collection('Users').snapshots().listen((event) {
      for (var i in event.docs) {
        //print(i.get('username'));
        if (i.id != _auth.currentUser?.uid){
        users.add('${i.get('username')}');
        //print(i.get('phone'));
        pno.add(i.get('phone'));
        desig.add(i.get('designation'));
        purl.add(i.get('photourl'));
      }}
    });
    getdat();
  }

  Future<void> getdat() async {
    final newUser = _auth.currentUser;
    uid = newUser!.uid;
    firestoreInstance.collection('Users').doc('$uid').update({'status': true});
  }
  Future<void> _launcchat(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }
  @override
  void dispose() {
    super.dispose();
    firestoreInstance.collection('Users').doc('$uid').update({'status': false});
  }

  Widget build(BuildContext context) {
    double height(double height) {
      return MediaQuery.of(context).size.height * height;
    }

    double width(double width) {
      return MediaQuery.of(context).size.width * width;
    }

    Future<Null> refreshList() async {
      await Future.delayed(Duration(seconds: 2));
      users.clear();
      pno.clear();
      desig.clear();
      purl.clear();
      await Future.delayed(Duration(seconds: 1));
      getdat();
    }

    Widget chatBox(String name, String url, String lastMessage, String time) {
      return Container(
        height: height(0.08),
        width: width(1),
        child: InkWell(
          onTap: () {},
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(url),
                radius: 28,
                backgroundColor: Colors.blueGrey,
              ),
              Padding(
                padding: EdgeInsets.only(top: height(0.015), left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      lastMessage,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Chat"),
          centerTitle: true,
            backgroundColor: Colors.transparent,
          leading: IconButton(onPressed:(){Navigator.pop(context);} ,icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,),),
          actions: [
            IconButton(onPressed: () {
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>search()));
            }, icon: Icon(Icons.search,color: Colors.white,)),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 27, 33, 41),
        body: SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 1, minWidth: 1),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RefreshIndicator(
                    onRefresh: refreshList,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: firestoreInstance.collection('Users').snapshots(),
                      builder: (context, snapshot) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            if (users.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    child: Text(
                                  'No Data to show',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                )),
                              );
                            } else {
                              return SingleChildScrollView(
                                child: ListTile(
                                  trailing: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        url = "https://wa.me/${pno[index]}";
                                      });

                                      _launcchat(url);
                                    },
                                    icon: Icon(
                                      Icons.chat,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: chatBox(users[index], purl[index],
                                      "" + desig[index], "18:20"),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
