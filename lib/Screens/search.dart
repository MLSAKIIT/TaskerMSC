// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class search extends StatefulWidget {
  const search({Key? key}) : super(key: key);

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  final _auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  List<String> users = [];
  List<String> pno = [];
  List<String> desig = [];
  List<String> purl = [];
  List<Map<String, dynamic>> _foundUsers = [];
  List<Map<String, dynamic>> Users = [];
  String uid = "";
  String url = "";
  @override
  void initState() {
    super.initState();
    getdat();

    //print(Users.first);
  }

  Future<void> getdat() async {
    final newUser = _auth.currentUser;
    uid = newUser!.uid;
    firestoreInstance.collection('Users').snapshots().listen((event) {
      for (var i in event.docs) {
        if (i.id != _auth.currentUser?.uid) {
          Users.add({
            "username": i.get('username'),
            "phone": i.get('phone'),
            "desig": i.get('designation'),
            "purl": i.get('photourl')
          });
        }
      }
    });
    _foundUsers = Users;
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

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    Users.clear();
    await Future.delayed(Duration(seconds: 1));
    getdat();
  }

  @override
  void dispose() {
    super.dispose();
    firestoreInstance.collection('Users').doc('$uid').update({'status': false});
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = Users;
    } else {
      results = Users.where((user) => user["username"]
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase())).toList();
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color.fromARGB(255, 27, 33, 41),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshList,
          backgroundColor: Colors.blue[900],
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  onChanged: (value) => _runFilter(value),
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Search',
                    suffixIcon: Icon(Icons.search, color: Colors.white),
                    labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: _foundUsers.isNotEmpty
                      ? StreamBuilder<QuerySnapshot>(
                          stream:
                              firestoreInstance.collection('Users').snapshots(),
                          builder: (context, snapshot) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: _foundUsers.length,
                              itemBuilder: (context, index) => Card(
                                key: ValueKey(_foundUsers[index]["id"]),
                                color: Colors.grey,
                                elevation: 4,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        '${_foundUsers[index]['purl']}'),
                                    radius: 28,
                                    backgroundColor: Colors.blueGrey,
                                  ),
                                  title: Text(_foundUsers[index]['username']),
                                  subtitle:
                                      Text('${_foundUsers[index]["desig"]}'),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.chat,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _launcchat(
                                          "https://wa.me/${_foundUsers[index]['phone']}");
                                    },
                                  ),
                                ),
                              ),
                            );
                          })
                      : const Text(
                          'No results found',
                          style: TextStyle(fontSize: 24, color: Colors.white),
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
