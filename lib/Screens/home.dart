// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskermsc/Screens/FAQ.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  String _url = 'https://meet.google.com';
  final _auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  String username = "";
  String uid = "";
  String Task = "";
  String priority = "";
  String meet = "";
  String tdet = "";
  bool mcreate = false;
  double _priority = 0;
  DateTime _sdate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  int all = 0;
  List<DateTime> date = [];
  List<String> task = [];
  List<String> meetl = [];
  List<String> uids = [];
  List<String> users = [];
  List<String> udesig = [];
  List<String> uno = [];
  List<String> tdetail = [];
  List<bool>tstat=[];
  List<String>assignee=[];
  String chattext = "";
  //List <String> priority=[];
  List<bool> Status = [];
  List pcol1 = [];
  List<Map<String, dynamic>> _foundUsers = [];
  List<Map<String, dynamic>> _Users = [];

  @override
  void initState() {
    super.initState();
    getdat();
    _edate();
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                playSound: true,
                colorized: true,
                icon: '@mipmap/ic_launcher',
              ),
            ),
          );
        }
      },
    );
    Future<Null> refreshUsers() async {
      await Future.delayed(Duration(seconds: 2));
      users.clear();
      await Future.delayed(Duration(seconds: 1));
      getdat();
    }

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        print('A new onMessageOpenedApp event was published!');
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('${notification.title}'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text('${notification.body}')],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  void showNotification() {
    setState(() {});
    flutterLocalNotificationsPlugin.show(
        0,
        "Tasker",
        "New Task Created at ${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  void _edate() {
    for (int i = 0; i < date.length; i++) {
      if (date[i].difference(DateTime.now()).inHours.toInt() < 2) {
        flutterLocalNotificationsPlugin.show(
            0,
            "Tasker",
            "One of your tasks is near deadline, or has crossed it, please check",
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    importance: Importance.high,
                    color: Colors.blue,
                    playSound: true,
                    icon: '@mipmap/ic_launcher')));
      }
    }
  }

  Future<void> getdat() async {
    final newUser = _auth.currentUser;
    _sdate = DateTime.now();
    //print(newUser?.uid);
    uid = newUser!.uid;
    print(uid);
    firestoreInstance
        .collection('Users')
        .doc('$uid')
        .snapshots()
        .listen((event) {
      all = event.get('number');
    });

    firestoreInstance
        .collection("Users")
        .doc('$uid')
        .collection('Task')
        .snapshots()
        .listen((event) {
      for (var list in event.docs) {
        Timestamp timestamp = list.get('Date');
        var result = DateTime.fromMicrosecondsSinceEpoch(
            timestamp.microsecondsSinceEpoch);
        //print(result);
        date.add(result);
        var task1 = list.get('Task');
        task.add(task1);
        var sta = list.get('status');
        Status.add(sta);
        var link = list.get('meet');
        meetl.add(link);
        //print(link);
        var assigner=list.get('assignee');
        assignee.add(assigner);
        var det = list.get('Details');
        tdetail.add(det);
        var prio = list.get('Priority');
        // priority.add(prio);
        if (prio == "green") {
          setState(() {
            pcol1.add(AssetImage("assets/green_background.jpg"));
          });
        }
        if (prio == "yellow") {
          setState(() {
            pcol1.add(AssetImage("assets/yellow_background.png"));
          });
        }
        if (prio == "red") {
          setState(() {
            pcol1.add(AssetImage("assets/red_background.jpg"));
          });
        }
      }
    });
    firestoreInstance.collection('Users').snapshots().listen((event) {
      for (var i in event.docs) {
        if (i.id != _auth.currentUser?.uid) {
          _Users.add({
            "id": i.id,
            "username": i.get('username'),
            "phone": i.get('phone'),
            "desig": i.get('designation')
          });
        }
      }
    });
    _foundUsers = _Users;
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _Users;
    } else {
      results = _Users.where((user) => user["username"]
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase())).toList();
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  Future<void> _launchInWebViewOrVC(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
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

  Future<void> _launchmeet(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }

  String etime = "";
  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (selected != null && selected != selectedTime) {
      setState(() {
        selectedTime = selected;
        etime = "${selectedTime.hour}:${selectedTime.minute}";
      });
      //print(etime);
    }
    return selectedTime;
  }

  DateTime selectedDate = DateTime.now();
  Future<DateTime> selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
    return selectedDate;
  }

  DateTime dateTime = DateTime.now();
  Future _selectDateTime(BuildContext context) async {
    final date = await selectDate(context);
    if (date == null) return;

    final time = await _selectTime(context);

    if (time == null) return;
    setState(() {
      dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
    //print(dateTime);
  }

  // Gives height and width according to screen size
  double height(double height) {
    return MediaQuery.of(context).size.height * height;
  }

  double width(double width) {
    return MediaQuery.of(context).size.width * width;
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      Task = "";
    });
    date.clear();
    task.clear();
    meetl.clear();
    uids.clear();
    users.clear();
    udesig.clear();
    uno.clear();
    Status.clear();
    pcol1.clear();
    tdetail.clear();
    _Users.clear();
    await Future.delayed(Duration(seconds: 1));
    getdat();
    await Future.delayed(Duration(seconds: 1));
    _edate();
  }

  Future<Null> refreshUser() async {
    await Future.delayed(Duration(seconds: 2));
    uids.clear();
    users.clear();
    udesig.clear();
    uno.clear();
    _Users.clear();
    await Future.delayed(Duration(seconds: 1));
    getdat();
    await Future.delayed(Duration(seconds: 1));
    _edate();
  }

  Future<Null> refresh() async {
    await Future.delayed(Duration(seconds: 2));

    users.clear();

    await Future.delayed(Duration(seconds: 1));
    getdat();
  }

  ScrollController scrollController = ScrollController(
    initialScrollOffset: 10,
    keepScrollOffset: true,
  );

  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 27, 33, 41),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text("Home"),
            centerTitle: true,
            elevation: 0,
            bottom: const TabBar(
              tabs: [
                Tab(
                  child: Text("Current"),
                ),
                Tab(
                  child: Text("Missing"),
                ),
                Tab(
                  child: Text("All"),
                ),
              ],
              indicatorColor: Colors.white,
            ),
            actions: [
              IconButton(onPressed: (){
                Navigator.pushNamed(context,'/fa');
              }, icon:Icon(Icons.help,color: Colors.white,))
            ],
          ),
          drawer: Drawer(
            backgroundColor: Color.fromARGB(255, 36, 40, 42),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/dark_blue.jpg"),
                        fit: BoxFit.cover),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage(_auth.currentUser?.photoURL as String),
                        radius: 28,
                        backgroundColor: Colors.blueGrey,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _auth.currentUser!.displayName.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "${_auth.currentUser!.email}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.teal,
                  ),
                  title: Text("Home", style: TextStyle(color: Colors.white)),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.teal,
                  ),
                  title:
                      Text("About Us", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    showModalBottomSheet(
                        backgroundColor: Color.fromARGB(255, 56, 61, 65),
                        context: context,
                        builder: (BuildContext bs) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: height(0.1)),

                                SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  // height: 100,
                                  // width: 500,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: height(0.25),
                                        child: Center(
                                          child: Image.asset("assets/MSC.png"),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        // ignore: prefer_const_literals_to_create_immutables
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 57.0),
                                            child: Text(
                                              "Microsoft",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.teal,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Text(
                                            "Student Community",
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.teal,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 63.0),
                                            child: Text(
                                              "KiiT Chapter",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.teal,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height(0.05),
                                ),
                                //Divider(color: Colors.blue, thickness: 2),
                                Divider(color: Colors.white),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(color: Color.fromARGB(246, 2, 105, 184),
                                    elevation:10,
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                          "Microsoft Learn Student Ambassadors are a global group of on-campus ambassadors sponsored by Microsoft who are eager to help fellow students, lead in their local tech community,and develop technical and career skills for the future. ",
                                          style: TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ),
                                Divider(color: Colors.white),

                                Center(
                                    child: Text("Developer Team",
                                        style: TextStyle(
                                            color: Colors.cyan, fontSize: 30))),
                                SizedBox(
                                  height: height(0.02),
                                ),

                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        color: Color.fromARGB(246, 2, 105,
                                            184)), //rgba(2, 105, 184, 1)
                                    height: height(0.1),
                                    width: width(0.85),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        //•

                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text("Prashant Upadhyay",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // SizedBox(
                                            //   width: width(0.18),
                                            // ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Text(
                                                      "• Backend   • UI   • Management",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                      )),
                                                ),
                                                // Text("",
                                                //     style: TextStyle(
                                                //       color: Colors.white,
                                                //       fontSize: 18,
                                                //     )),
                                                // Text("",
                                                //     style: TextStyle(
                                                //       color: Colors.white,
                                                //       fontSize: 18,
                                                //     ))
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    )),
                                SizedBox(
                                  height: height(0.015),
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        color:
                                            Color.fromARGB(246, 2, 105, 184)),
                                    height: height(0.1),
                                    width: width(0.85),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        //•

                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text("Shashank Deepak",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // SizedBox(
                                            //   width: width(0.18),
                                            // ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Text(
                                                      "• UI / UX • Debugging  ",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                      )),
                                                ),
                                                // Text("",
                                                //     style: TextStyle(
                                                //       color: Colors.white,
                                                //       fontSize: 18,
                                                //     )),
                                                // Text("",
                                                //     style: TextStyle(
                                                //       color: Colors.white,
                                                //       fontSize: 18,
                                                //     ))
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    )),
                                SizedBox(
                                  height: height(0.015),
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        color:
                                            Color.fromARGB(246, 2, 105, 184)),
                                    height: height(0.1),
                                    width: width(0.85),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        //•

                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text("Ankit Kumar",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // SizedBox(
                                            //   width: width(0.18),
                                            // ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Text(
                                                      "• Testing • Bug Finding",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                      )),
                                                ),
                                                // Text("",
                                                //     style: TextStyle(
                                                //       color: Colors.white,
                                                //       fontSize: 18,
                                                //     )),
                                                // Text("",
                                                //     style: TextStyle(
                                                //       color: Colors.white,
                                                //       fontSize: 18,
                                                //     ))
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    )),
                                SizedBox(
                                  height: height(0.015),
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        color:
                                            Color.fromARGB(246, 2, 105, 184)),
                                    height: height(0.1),
                                    width: width(0.85),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        //•

                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text("Pranshu Sarthak",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // SizedBox(
                                            //   width: width(0.18),
                                            // ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Text(
                                                      "• Testing  • Bug Finding",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                      )),
                                                ),
                                                // Text("",
                                                //     style: TextStyle(
                                                //       color: Colors.white,
                                                //       fontSize: 18,
                                                //     )),
                                                // Text("",
                                                //     style: TextStyle(
                                                //       color: Colors.white,
                                                //       fontSize: 18,
                                                //     ))
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    )),
                                SizedBox(
                                  height: height(0.015),
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        color:
                                            Color.fromARGB(246, 2, 105, 184)),
                                    height: height(0.1),
                                    width: width(0.85),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        //•

                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text("Rakshita",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // SizedBox(
                                            //   width: width(0.18),
                                            // ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Text(
                                                      "• Creative   • Logo   • Images",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                      )),
                                                ),
                                                // Text("",
                                                //     style: TextStyle(
                                                //       color: Colors.white,
                                                //       fontSize: 18,
                                                //     )),
                                                // Text("",
                                                //     style: TextStyle(
                                                //       color: Colors.white,
                                                //       fontSize: 18,
                                                //     ))
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    )),
                                SizedBox(
                                  height: height(0.015),
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        color:
                                            Color.fromARGB(246, 2, 105, 184)),
                                    height: height(0.1),
                                    width: width(0.85),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        //•

                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text("Bibek",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // SizedBox(
                                            //   width: width(0.18),
                                            // ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Text("• UI Revamp",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                      )),
                                                ),

                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    )),
                              ],
                            ),
                          );
                        },
                        isScrollControlled: true);
                  },
                ),

                ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Colors.teal,
                  ),
                  title: Text("Logout", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    _auth.signOut();
                    Navigator.pop(context);
                    //exit(0);
                  },
                ),
                Text("v 1.0  © MSC KIIT",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          body: SafeArea(
              child: TabBarView(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 550,
                      child: RefreshIndicator(
                        onRefresh: refreshList,
                        backgroundColor: Colors.blue[900],
                        color: Colors.white,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: firestoreInstance
                                .collection("Users")
                                .doc('$uid')
                                .collection('Task')
                                .snapshots(),
                            builder: (context, snapshot) {
                              return task!.isNotEmpty ? ListView.builder(
                                  controller: scrollController,
                                  itemCount: task.isEmpty ? 0 : task.length,
                                  itemBuilder: (context, int index) {
                                    if (date[index].difference(DateTime.now()).isNegative !=true && Status[index]==false) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: OutlinedButton(
                                          child: Card(
                                            clipBehavior: Clip.antiAlias,
                                            elevation: 20,
                                            margin: EdgeInsets.all(0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(20)),
                                            child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minHeight: height(0.13),
                                                minWidth: width(1),
                                              ),
                                              child: Container(
                                                // height: 90,
                                                // width: width(1),
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: pcol1[index],
                                                      fit: BoxFit.cover),
                                                  borderRadius:
                                                  BorderRadius.circular(18),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceEvenly,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          EdgeInsets.only(
                                                              top: 20,
                                                              left: 10,
                                                              right: 10),
                                                          child: Text(
                                                            "${task[index]}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                height(
                                                                    0.024),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                          EdgeInsets.only(
                                                              top: 20,
                                                              left: 10,
                                                              bottom: 10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "End Date: " +
                                                                    "${(date[index].day)}-${(date[index].month)}-${(date[index].year)}" +
                                                                    "\nEnd Time: "
                                                                        "${date[index].hour}:${date[index].minute}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                    height(
                                                                        0.02),
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                              SizedBox(
                                                                width: 50,
                                                              ),
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    showDialog<
                                                                        void>(
                                                                      context:
                                                                      context,
                                                                      barrierDismissible:
                                                                      true,
                                                                      // user must tap button!
                                                                      builder:
                                                                          (BuildContext
                                                                      context) {
                                                                        return AlertDialog(
                                                                          shape:
                                                                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                                                                          backgroundColor: Color.fromARGB(
                                                                              255,
                                                                              48,
                                                                              48,
                                                                              54),
                                                                          title:
                                                                          Padding(
                                                                            padding:
                                                                            const EdgeInsets.only(left: 12, top: 10),
                                                                            child:
                                                                            const Text(
                                                                              'Update Task',
                                                                              style: TextStyle(color: Color.fromARGB(255, 250, 251, 252), fontSize: 28),
                                                                            ),
                                                                          ),
                                                                          content:
                                                                          SingleChildScrollView(
                                                                            child:
                                                                            Material(
                                                                              color: Color.fromARGB(255, 48, 48, 54),
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 4.0, bottom: 20),
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(5)),
                                                                                      width: 350,
                                                                                      height: 50,
                                                                                      padding: EdgeInsets.only(left: 4),
                                                                                      child: TextFormField(
                                                                                        style: TextStyle(fontSize: 18, color: Colors.white),
                                                                                        decoration: InputDecoration(border: InputBorder.none, hintText: "Title here(<25 chars)", hintStyle: TextStyle(color: Colors.grey)),
                                                                                        keyboardType: TextInputType.visiblePassword,
                                                                                        obscureText: false,
                                                                                        onChanged: (value) {
                                                                                          Task = value;
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
                                                                                      width: 350,
                                                                                      height: 50,
                                                                                      padding: EdgeInsets.only(left: 4),
                                                                                      child: TextFormField(
                                                                                        style: TextStyle(fontSize: 18, color: Colors.white),
                                                                                        decoration: InputDecoration(border: InputBorder.none, hintText: "Details here/Event Name", hintStyle: TextStyle(color: Colors.grey)),
                                                                                        keyboardType: TextInputType.visiblePassword,
                                                                                        obscureText: false,
                                                                                        onChanged: (value) {
                                                                                          tdet = value;
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 30,
                                                                                  ),
                                                                                  Text(
                                                                                    "Set Priority",
                                                                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                                                                  ),
                                                                                  StatefulBuilder(
                                                                                    builder: (context, setState) => Slider(
                                                                                      value: _priority,
                                                                                      max: 9,
                                                                                      divisions: 9,
                                                                                      label: "Priority:${(_priority + 1).round().toString()}",
                                                                                      onChanged: (double value) {
                                                                                        // print("$value");
                                                                                        setState(() {
                                                                                          _priority = value;
                                                                                        });
                                                                                        //print(_priority.round());
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 20,
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                    children: [
                                                                                      Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: <Widget>[
                                                                                          IconButton(
                                                                                            icon: const Icon(
                                                                                              Icons.person_add,
                                                                                              color: Colors.white,
                                                                                            ),
                                                                                            tooltip: 'Add collaborators',
                                                                                            onPressed: () {
                                                                                              showModalBottomSheet(
                                                                                                  backgroundColor: Color.fromARGB(255, 0, 0, 0),
                                                                                                  context: context,
                                                                                                  builder: (BuildContext bc) {
                                                                                                    return StreamBuilder<QuerySnapshot>(
                                                                                                        stream: firestoreInstance.collection("Users").snapshots(),
                                                                                                        builder: (context, snapshot) {
                                                                                                          return Padding(
                                                                                                            padding: const EdgeInsets.all(10),
                                                                                                            child: Column(
                                                                                                              children: [
                                                                                                                const SizedBox(
                                                                                                                  height: 20,
                                                                                                                ),
                                                                                                                TextField(
                                                                                                                  onChanged: (value) => _runFilter(value),
                                                                                                                  decoration: const InputDecoration(labelText: 'Search', suffixIcon: Icon(Icons.search)),
                                                                                                                ),
                                                                                                                const SizedBox(
                                                                                                                  height: 20,
                                                                                                                ),
                                                                                                                Expanded(
                                                                                                                  child: _foundUsers.isNotEmpty
                                                                                                                      ? RefreshIndicator(
                                                                                                                    onRefresh: refreshList,
                                                                                                                    backgroundColor: Colors.blue[900],
                                                                                                                    color: Colors.white,
                                                                                                                    child: StreamBuilder<QuerySnapshot>(
                                                                                                                        stream: firestoreInstance.collection('Users').snapshots(),
                                                                                                                        builder: (context, snapshot) {
                                                                                                                          return ListView.builder(
                                                                                                                            shrinkWrap: true,
                                                                                                                            itemCount: _foundUsers.length,
                                                                                                                            itemBuilder: (context, index) => Card(
                                                                                                                              key: ValueKey(_foundUsers[index]["id"]),
                                                                                                                              color: Colors.grey,
                                                                                                                              elevation: 4,
                                                                                                                              margin: const EdgeInsets.symmetric(vertical: 10),
                                                                                                                              child: ListTile(
                                                                                                                                leading: IconButton(
                                                                                                                                  onPressed: () {
                                                                                                                                    setState(() {
                                                                                                                                      all = all + 1;
                                                                                                                                      if (_priority.toInt() >= 0 && _priority.toInt() < 4) {
                                                                                                                                        setState(() {
                                                                                                                                          priority = "green";
                                                                                                                                        });
                                                                                                                                      } else if (_priority.toInt() >= 4 && _priority.toInt() <= 7) {
                                                                                                                                        setState(() {
                                                                                                                                          priority = "yellow";
                                                                                                                                        });
                                                                                                                                      } else {
                                                                                                                                        setState(() {
                                                                                                                                          priority = "red";
                                                                                                                                        });
                                                                                                                                      }
                                                                                                                                    });

                                                                                                                                    firestoreInstance.collection("Users").doc('${_foundUsers[index]['id']}').collection('Task').doc('${date[index]}').set({
                                                                                                                                      'Task': Task,
                                                                                                                                      'Date': date[index],
                                                                                                                                      'Priority': priority,
                                                                                                                                      'status': false,
                                                                                                                                      'sdate': _sdate,
                                                                                                                                      'meet': meet,
                                                                                                                                      'assignee':_auth.currentUser?.displayName,
                                                                                                                                      'Details': tdet,
                                                                                                                                    });
                                                                                                                                    showDialog(
                                                                                                                                        context: context,
                                                                                                                                        barrierDismissible: true,
                                                                                                                                        builder: (BuildContext bs) {
                                                                                                                                          return AlertDialog(
                                                                                                                                            title: Text("Task Assigned to ${_foundUsers[index]['username']}"),
                                                                                                                                          );
                                                                                                                                        });
                                                                                                                                    _launcchat("https://wa.me/${_foundUsers[index]['phone']}?text=Task: ${Task} assigned to you by ${_auth.currentUser?.displayName}, check your app for new tasks");
                                                                                                                                  },
                                                                                                                                  icon: Icon(Icons.add),
                                                                                                                                ),
                                                                                                                                title: Text(_foundUsers[index]['username']),
                                                                                                                                subtitle: Text('${_foundUsers[index]["desig"]}'),
                                                                                                                                trailing: IconButton(
                                                                                                                                  icon: Icon(
                                                                                                                                    Icons.chat,
                                                                                                                                    color: Colors.white,
                                                                                                                                  ),
                                                                                                                                  onPressed: () {
                                                                                                                                    _launcchat("https://wa.me/${_foundUsers[index]['phone']}?text=Please check your app for new tasks");
                                                                                                                                  },
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                          );
                                                                                                                        }),
                                                                                                                  )
                                                                                                                      : const Text(
                                                                                                                    'No results found',
                                                                                                                    style: TextStyle(fontSize: 24),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          );
                                                                                                        });
                                                                                                  });
                                                                                            },
                                                                                          ),
                                                                                          Text(
                                                                                            'Collaborate',
                                                                                            style: TextStyle(color: Colors.white),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                      Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: <Widget>[
                                                                                          IconButton(
                                                                                            icon: const Icon(
                                                                                              Icons.calendar_today,
                                                                                              color: Colors.white,
                                                                                            ),
                                                                                            tooltip: 'Add meet',
                                                                                            onPressed: () {
                                                                                              /*_launchInWebViewOrVC(
                                                                        _url);*/
                                                                                              setState(() {
                                                                                                mcreate = true;
                                                                                                print("meet$mcreate");
                                                                                              });
                                                                                            },
                                                                                          ),
                                                                                          Text(
                                                                                            'Meeting',
                                                                                            style: TextStyle(color: Colors.white),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: EdgeInsets.only(top: 40),
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
                                                                                      width: 350,
                                                                                      height: 50,
                                                                                      padding: EdgeInsets.only(left: 4),
                                                                                      child: TextFormField(
                                                                                        style: TextStyle(fontSize: 18, color: Colors.white),
                                                                                        decoration: InputDecoration(border: InputBorder.none, hintText: "Meet link here", hintStyle: TextStyle(color: Colors.grey)),
                                                                                        keyboardType: TextInputType.visiblePassword,
                                                                                        obscureText: false,
                                                                                        onChanged: (value) {
                                                                                          meet = value;
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          actions: <
                                                                              Widget>[
                                                                            MaterialButton(
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  all = all - 1;
                                                                                  if (_priority.toInt() >= 0 && _priority.toInt() < 4) {
                                                                                    setState(() {
                                                                                      priority = "green";
                                                                                    });
                                                                                  } else if (_priority.toInt() >= 4 && _priority.toInt() <= 7) {
                                                                                    setState(() {
                                                                                      priority = "yellow";
                                                                                    });
                                                                                  } else {
                                                                                    setState(() {
                                                                                      priority = "red";
                                                                                    });
                                                                                  }
                                                                                });
                                                                                firestoreInstance.collection("Users").doc('$uid').collection('Task').doc('${date[index]}').update({
                                                                                  'Task': Task,
                                                                                  //'Date': dateTime,
                                                                                  'Priority': priority,
                                                                                  'status': false,
                                                                                  'assignee':_auth.currentUser?.displayName,
                                                                                  'meet': meet,
                                                                                  'Details': tdet,
                                                                                });
                                                                                firestoreInstance.collection("Users").doc("$uid").update({
                                                                                  'number': all
                                                                                });
                                                                                refreshList();
                                                                                Navigator.pop(context);
                                                                              },
                                                                              color: Colors.blue[900],
                                                                              child: Text(
                                                                                "Update",
                                                                                style: TextStyle(color: Colors.white),
                                                                              ),
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                                            ),
                                                                            MaterialButton(
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  all = all - 1;
                                                                                });
                                                                                firestoreInstance.collection("Users").doc('$uid').collection('Task').doc('${date[index]}').update(
                                                                                    {
                                                                                      'status': true,
                                                                                    });
                                                                                firestoreInstance.collection("Users").doc('$uid').update({
                                                                                  'number': all
                                                                                });
                                                                                Navigator.pop(context);
                                                                                refreshList();
                                                                              },
                                                                              color: Colors.blue[900],
                                                                              child: Text(
                                                                                "Mark as Done",
                                                                                style: TextStyle(color: Colors.white),
                                                                              ),
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                                            ),
                                                                            SizedBox(height: 40)
                                                                          ],
                                                                          elevation:
                                                                          24,
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                  icon: Icon(
                                                                    Icons.edit,
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    showDialog<
                                                                        void>(
                                                                      context:
                                                                      context,
                                                                      barrierDismissible:
                                                                      false, // user must tap button!
                                                                      builder:
                                                                          (BuildContext
                                                                      context) {
                                                                        return AlertDialog(
                                                                          backgroundColor: Color.fromARGB(
                                                                              255,
                                                                              71,
                                                                              71,
                                                                              79),
                                                                          title: const Text(
                                                                              'Details',
                                                                              style: TextStyle(color: Colors.white)),
                                                                          content:
                                                                          SingleChildScrollView(
                                                                            child:
                                                                            ListBody(
                                                                              children: <Widget>[
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Text("Task: ${task[index]}", style: TextStyle(color: Colors.white)),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Text("Details: ${tdetail[index]}", style: TextStyle(color: Colors.white)),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Text("Ends on: ${(date[index].day)}-${(date[index].month)}-${(date[index].year)} ${date[index].hour}:${date[index].minute}", style: TextStyle(color: Colors.white)),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Text("Assigned by: ${assignee[index]}", style: TextStyle(color: Colors.white)),
                                                                                ),

                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: TextButton(
                                                                                      onPressed: () {
                                                                                        _launchmeet("https://${meetl[index]}");
                                                                                      },
                                                                                      child: Text("Meet Link: ${(meetl[index])}")),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          actions: <
                                                                              Widget>[
                                                                            TextButton(
                                                                              child: const Text('Accept'),
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                            ),
                                                                          ],
                                                                          elevation:
                                                                          24,
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                  icon: Icon(
                                                                    Icons
                                                                        .remove_red_eye,
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                        //Text("${Status[index]}"),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {},

                                          //
                                        ),
                                      );
                                    } else {
                                      return Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 5,),
                                          /*Center(
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    8, 200, 8, 8),
                                                child: Image(
                                                  image: AssetImage("assets/2.png"),
                                                  height: 150,
                                                  width: 200,
                                                  color:
                                                  Colors.white.withOpacity(0.5),
                                                  colorBlendMode:
                                                  BlendMode.modulate,
                                                ),
                                              )),
                                          Text(
                                            "No Up-Coming Tasks",
                                            style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.7),
                                                fontSize: 22),
                                          ),*/
                                        ],
                                      );
                                    }
                                  }):Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8, 8, 8, 8),
                                    child: Image(
                                      image: AssetImage("assets/2.png"),
                                      height: 150,
                                      width: 200,
                                      color:
                                      Colors.white.withOpacity(0.5),
                                      colorBlendMode: BlendMode.modulate,
                                    ),
                                  ),
                                  Text(
                                    "No Up-Coming Tasks",
                                    style: TextStyle(
                                        color:
                                        Colors.white.withOpacity(0.7),
                                        fontSize: 22),
                                  ),
                                ],
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    RefreshIndicator(
                      onRefresh: refreshList,
                      backgroundColor: Colors.purple,
                      color: Colors.white,
                      child: Container(
                        height: 550,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: firestoreInstance
                                .collection("Users")
                                .doc('$uid')
                                .collection('Task')
                                .snapshots(),
                            builder: (context, snapshot) {
                              return task!.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: task.isEmpty ? 0 : task.length,
                                      itemBuilder: (context, int index) {
                                        if (date[index]
                                                .difference(DateTime.now())
                                                .isNegative ==
                                            true && Status[index]==false) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: OutlinedButton(
                                              child: Card(
                                                clipBehavior: Clip.antiAlias,
                                                elevation: 20,
                                                margin: EdgeInsets.all(0),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                    minHeight: height(0.13),
                                                    minWidth: width(1),
                                                  ),
                                                  child: Container(
                                                    // height: 90,
                                                    // width: width(1),
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: pcol1[index],
                                                          fit: BoxFit.cover),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 20,
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                              child: Text(
                                                                "${task[index]}",
                                                                softWrap: false,
                                                                maxLines: 10,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        height(
                                                                            0.024),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),

                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 20,
                                                                      left: 10,
                                                                      bottom:
                                                                          10),
                                                              child: Text(
                                                                "${(date[index].day)}-${(date[index].month)}-${(date[index].year)} ${date[index].hour}:${date[index].minute}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        height(
                                                                            0.02),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            //Text("${Status[index]}"),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: 100,
                                                        ),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            IconButton(
                                                                onPressed: () {
                                                                  showDialog<
                                                                      void>(
                                                                    context:
                                                                        context,
                                                                    barrierDismissible:
                                                                        false, // user must tap button!
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        backgroundColor: Color.fromARGB(
                                                                            255,
                                                                            71,
                                                                            71,
                                                                            79),
                                                                        title: const Text(
                                                                            'Details',
                                                                            style:
                                                                                TextStyle(color: Colors.white)),
                                                                        content:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              ListBody(
                                                                            children: <Widget>[
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Text("Task: ${task[index]}", style: TextStyle(color: Colors.white)),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Text("Details: ${tdet[index]}", style: TextStyle(color: Colors.white)),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Text("Ends on: ${(date[index].day)}-${(date[index].month)}-${(date[index].year)} ${date[index].hour}:${date[index].minute}", style: TextStyle(color: Colors.white)),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Text("Assigned by: ${assignee[index]}", style: TextStyle(color: Colors.white)),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Text("Image:"),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: TextButton(
                                                                                    onPressed: () {
                                                                                      _launchmeet("https://${meetl[index]}");
                                                                                    },
                                                                                    child: Text("Meet Link: ${(meetl[index])}")),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        actions: <
                                                                            Widget>[
                                                                          TextButton(
                                                                            child:
                                                                                const Text('Accept'),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          ),
                                                                        ],
                                                                        elevation:
                                                                            24,
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                icon: Icon(
                                                                  Icons
                                                                      .remove_red_eye,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {},

                                              //
                                            ),
                                          );
                                        } else {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 5,),
                                             /* Center(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 200, 8, 8),
                                                child: Image(
                                                  image: AssetImage(
                                                      "assets/2.png"),
                                                  height: 150,
                                                  width: 200,
                                                  color: Colors.white
                                                      .withOpacity(0.5),
                                                  colorBlendMode:
                                                      BlendMode.modulate,
                                                ),
                                              )),
                                              Text(
                                                "No Old Tasks",
                                                style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.7),
                                                    fontSize: 22),
                                              ),*/
                                            ],
                                          );
                                        }
                                      })
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 8, 8, 8),
                                          child: Image(
                                            image: AssetImage("assets/2.png"),
                                            height: 150,
                                            width: 200,
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            colorBlendMode: BlendMode.modulate,
                                          ),
                                        ),
                                        Text(
                                          "No Old Tasks",
                                          style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                              fontSize: 22),
                                        ),
                                      ],
                                    );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    RefreshIndicator(
                      onRefresh: refreshList,
                      backgroundColor: Colors.purple,
                      color: Colors.white,
                      child: Container(
                        height: 550,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: firestoreInstance
                                .collection("Users")
                                .doc('$uid')
                                .collection('Task')
                                .snapshots(),
                            builder: (context, snapshot) {
                              return task!.isNotEmpty ?
                                ListView.builder(
                                  itemCount: task.isEmpty ? 0 : task.length,
                                  itemBuilder: (context, int index) {
                                    if (task[index].isEmpty != true) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: OutlinedButton(
                                          child: Card(
                                            clipBehavior: Clip.antiAlias,
                                            elevation: 20,
                                            margin: EdgeInsets.all(0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minHeight: height(0.13),
                                                minWidth: width(1),
                                              ),
                                              child: Container(
                                                // height: 90,
                                                // width: width(1),
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: pcol1[index],
                                                      fit: BoxFit.cover),
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          EdgeInsets.only(
                                                              top: 20,
                                                              left: 10,
                                                              right: 10),
                                                          child: Text(
                                                            "${task[index]}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                height(
                                                                    0.024),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                          EdgeInsets.only(
                                                              top: 20,
                                                              left: 10,
                                                              bottom: 10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "End Date: " +
                                                                    "${(date[index].day)}-${(date[index].month)}-${(date[index].year)}" +
                                                                    "\nEnd Time: "
                                                                        "${date[index].hour}:${date[index].minute}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                    height(
                                                                        0.02),
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    showDialog<
                                                                        void>(
                                                                      context:
                                                                      context,
                                                                      barrierDismissible:
                                                                      true,
                                                                      // user must tap button!
                                                                      builder:
                                                                          (BuildContext
                                                                      context) {
                                                                        return AlertDialog(
                                                                          shape:
                                                                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                                                                          backgroundColor: Color.fromARGB(
                                                                              255,
                                                                              48,
                                                                              48,
                                                                              54),
                                                                          title:
                                                                          Padding(
                                                                            padding:
                                                                            const EdgeInsets.only(left: 12, top: 10),
                                                                            child:
                                                                            const Text(
                                                                              'Update Task',
                                                                              style: TextStyle(color: Color.fromARGB(255, 250, 251, 252), fontSize: 28),
                                                                            ),
                                                                          ),
                                                                          content:
                                                                          SingleChildScrollView(
                                                                            child:
                                                                            Material(
                                                                              color: Color.fromARGB(255, 48, 48, 54),
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 4.0, bottom: 20),
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(5)),
                                                                                      width: 350,
                                                                                      height: 50,
                                                                                      padding: EdgeInsets.only(left: 4),
                                                                                      child: TextFormField(
                                                                                        style: TextStyle(fontSize: 18, color: Colors.white),
                                                                                        decoration: InputDecoration(border: InputBorder.none, hintText: "Title here(<25 chars)", hintStyle: TextStyle(color: Colors.grey)),
                                                                                        keyboardType: TextInputType.visiblePassword,
                                                                                        obscureText: false,
                                                                                        onChanged: (value) {
                                                                                          Task = value;
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
                                                                                      width: 350,
                                                                                      height: 50,
                                                                                      padding: EdgeInsets.only(left: 4),
                                                                                      child: TextFormField(
                                                                                        style: TextStyle(fontSize: 18, color: Colors.white),
                                                                                        decoration: InputDecoration(border: InputBorder.none, hintText: "Details here/Event Name", hintStyle: TextStyle(color: Colors.grey)),
                                                                                        keyboardType: TextInputType.visiblePassword,
                                                                                        obscureText: false,
                                                                                        onChanged: (value) {
                                                                                          tdet = value;
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 30,
                                                                                  ),
                                                                                  Text(
                                                                                    "Set Priority",
                                                                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                                                                  ),
                                                                                  StatefulBuilder(
                                                                                    builder: (context, setState) => Slider(
                                                                                      value: _priority,
                                                                                      max: 9,
                                                                                      divisions: 9,
                                                                                      label: "Priority:${(_priority + 1).round().toString()}",
                                                                                      onChanged: (double value) {
                                                                                        // print("$value");
                                                                                        setState(() {
                                                                                          _priority = value;
                                                                                        });
                                                                                        //print(_priority.round());
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 20,
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                    children: [
                                                                                      Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: <Widget>[
                                                                                          IconButton(
                                                                                            icon: const Icon(
                                                                                              Icons.person_add,
                                                                                              color: Colors.white,
                                                                                            ),
                                                                                            tooltip: 'Add collaborators',
                                                                                            onPressed: () {
                                                                                              showModalBottomSheet(
                                                                                                  backgroundColor: Color.fromARGB(255, 0, 0, 0),
                                                                                                  context: context,
                                                                                                  builder: (BuildContext bc) {
                                                                                                    return StreamBuilder<QuerySnapshot>(
                                                                                                        stream: firestoreInstance.collection("Users").snapshots(),
                                                                                                        builder: (context, snapshot) {
                                                                                                          return Padding(
                                                                                                            padding: const EdgeInsets.all(10),
                                                                                                            child: Column(
                                                                                                              children: [
                                                                                                                const SizedBox(
                                                                                                                  height: 20,
                                                                                                                ),
                                                                                                                TextField(
                                                                                                                  onChanged: (value) => _runFilter(value),
                                                                                                                  decoration: const InputDecoration(labelText: 'Search', suffixIcon: Icon(Icons.search)),
                                                                                                                ),
                                                                                                                const SizedBox(
                                                                                                                  height: 20,
                                                                                                                ),
                                                                                                                Expanded(
                                                                                                                  child: _foundUsers.isNotEmpty
                                                                                                                      ? RefreshIndicator(
                                                                                                                    onRefresh: refreshList,
                                                                                                                    backgroundColor: Colors.blue[900],
                                                                                                                    color: Colors.white,
                                                                                                                    child: StreamBuilder<QuerySnapshot>(
                                                                                                                        stream: firestoreInstance.collection('Users').snapshots(),
                                                                                                                        builder: (context, snapshot) {
                                                                                                                          return ListView.builder(
                                                                                                                            shrinkWrap: true,
                                                                                                                            itemCount: _foundUsers.length,
                                                                                                                            itemBuilder: (context, index) => Card(
                                                                                                                              key: ValueKey(_foundUsers[index]["id"]),
                                                                                                                              color: Colors.grey,
                                                                                                                              elevation: 4,
                                                                                                                              margin: const EdgeInsets.symmetric(vertical: 10),
                                                                                                                              child: ListTile(
                                                                                                                                leading: IconButton(
                                                                                                                                  onPressed: () {
                                                                                                                                    setState(() {
                                                                                                                                      all = all + 1;
                                                                                                                                      if (_priority.toInt() >= 0 && _priority.toInt() < 4) {
                                                                                                                                        setState(() {
                                                                                                                                          priority = "green";
                                                                                                                                        });
                                                                                                                                      } else if (_priority.toInt() >= 4 && _priority.toInt() <= 7) {
                                                                                                                                        setState(() {
                                                                                                                                          priority = "yellow";
                                                                                                                                        });
                                                                                                                                      } else {
                                                                                                                                        setState(() {
                                                                                                                                          priority = "red";
                                                                                                                                        });
                                                                                                                                      }
                                                                                                                                    });

                                                                                                                                    firestoreInstance.collection("Users").doc('${_foundUsers[index]['id']}').collection('Task').doc('${date[index]}').set({
                                                                                                                                      'Task': Task,
                                                                                                                                      'Date': date[index],
                                                                                                                                      'Priority': priority,
                                                                                                                                      'status': false,
                                                                                                                                      'sdate': _sdate,
                                                                                                                                      'meet': meet,
                                                                                                                                      'assignee':_auth.currentUser?.displayName,
                                                                                                                                      'Details': tdet,
                                                                                                                                    });
                                                                                                                                    showDialog(
                                                                                                                                        context: context,
                                                                                                                                        barrierDismissible: true,
                                                                                                                                        builder: (BuildContext bs) {
                                                                                                                                          return AlertDialog(
                                                                                                                                            title: Text("Task Assigned to ${_foundUsers[index]['username']}"),
                                                                                                                                          );
                                                                                                                                        });
                                                                                                                                    _launcchat("https://wa.me/${_foundUsers[index]['phone']}?text=Task: ${Task} assigned to you by ${_auth.currentUser?.displayName}, check your app for new tasks");
                                                                                                                                  },
                                                                                                                                  icon: Icon(Icons.add),
                                                                                                                                ),
                                                                                                                                title: Text(_foundUsers[index]['username']),
                                                                                                                                subtitle: Text('${_foundUsers[index]["desig"]}'),
                                                                                                                                trailing: IconButton(
                                                                                                                                  icon: Icon(
                                                                                                                                    Icons.chat,
                                                                                                                                    color: Colors.white,
                                                                                                                                  ),
                                                                                                                                  onPressed: () {
                                                                                                                                    _launcchat("https://wa.me/${_foundUsers[index]['phone']}?text=Please check your app for new tasks");
                                                                                                                                  },
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                          );
                                                                                                                        }),
                                                                                                                  )
                                                                                                                      : const Text(
                                                                                                                    'No results found',
                                                                                                                    style: TextStyle(fontSize: 24),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          );
                                                                                                        });
                                                                                                  });
                                                                                            },
                                                                                          ),
                                                                                          Text(
                                                                                            'Collaborate',
                                                                                            style: TextStyle(color: Colors.white),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                      Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: <Widget>[
                                                                                          IconButton(
                                                                                            icon: const Icon(
                                                                                              Icons.calendar_today,
                                                                                              color: Colors.white,
                                                                                            ),
                                                                                            tooltip: 'Add meet',
                                                                                            onPressed: () {
                                                                                              /*_launchInWebViewOrVC(
                                                                        _url);*/
                                                                                              setState(() {
                                                                                                mcreate = true;
                                                                                                print("meet$mcreate");
                                                                                              });
                                                                                            },
                                                                                          ),
                                                                                          Text(
                                                                                            'Meeting',
                                                                                            style: TextStyle(color: Colors.white),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: EdgeInsets.only(top: 40),
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
                                                                                      width: 350,
                                                                                      height: 50,
                                                                                      padding: EdgeInsets.only(left: 4),
                                                                                      child: TextFormField(
                                                                                        style: TextStyle(fontSize: 18, color: Colors.white),
                                                                                        decoration: InputDecoration(border: InputBorder.none, hintText: "Meet link here", hintStyle: TextStyle(color: Colors.grey)),
                                                                                        keyboardType: TextInputType.visiblePassword,
                                                                                        obscureText: false,
                                                                                        onChanged: (value) {
                                                                                          meet = value;
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          actions: <
                                                                              Widget>[
                                                                            MaterialButton(
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  all = all - 1;
                                                                                  if (_priority.toInt() >= 0 && _priority.toInt() < 4) {
                                                                                    setState(() {
                                                                                      priority = "green";
                                                                                    });
                                                                                  } else if (_priority.toInt() >= 4 && _priority.toInt() <= 7) {
                                                                                    setState(() {
                                                                                      priority = "yellow";
                                                                                    });
                                                                                  } else {
                                                                                    setState(() {
                                                                                      priority = "red";
                                                                                    });
                                                                                  }
                                                                                });
                                                                                firestoreInstance.collection("Users").doc('$uid').collection('Task').doc('${date[index]}').update({
                                                                                  'Task': Task,
                                                                                  //'Date': dateTime,
                                                                                  'Priority': priority,
                                                                                  'status': false,
                                                                                  'assignee':_auth.currentUser?.displayName,
                                                                                  'meet': meet,
                                                                                  'Details': tdet,
                                                                                });
                                                                                firestoreInstance.collection("Users").doc("$uid").update({
                                                                                  'number': all
                                                                                });
                                                                                refreshList();
                                                                                Navigator.pop(context);
                                                                              },
                                                                              color: Colors.blue[900],
                                                                              child: Text(
                                                                                "Update",
                                                                                style: TextStyle(color: Colors.white),
                                                                              ),
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                                            ),
                                                                            MaterialButton(
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  all = all - 1;
                                                                                });
                                                                                firestoreInstance.collection("Users").doc('$uid').collection('Task').doc('${date[index]}').update(
                                                                                    {
                                                                                      'status': true,
                                                                                    });
                                                                                firestoreInstance.collection("Users").doc('$uid').update({
                                                                                  'number': all
                                                                                });
                                                                                Navigator.pop(context);
                                                                                refreshList();
                                                                              },
                                                                              color: Colors.blue[900],
                                                                              child: Text(
                                                                                "Mark as Done",
                                                                                style: TextStyle(color: Colors.white),
                                                                              ),
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                                            ),
                                                                            SizedBox(height: 40)
                                                                          ],
                                                                          elevation:
                                                                          24,
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                  icon: Icon(
                                                                    Icons.edit,
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    showDialog<
                                                                        void>(
                                                                      context:
                                                                      context,
                                                                      barrierDismissible:
                                                                      false, // user must tap button!
                                                                      builder:
                                                                          (BuildContext
                                                                      context) {
                                                                        return AlertDialog(
                                                                          backgroundColor: Color.fromARGB(
                                                                              255,
                                                                              71,
                                                                              71,
                                                                              79),
                                                                          title: const Text(
                                                                              'Details',
                                                                              style: TextStyle(color: Colors.white)),
                                                                          content:
                                                                          SingleChildScrollView(
                                                                            child:
                                                                            ListBody(
                                                                              children: <Widget>[
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Text("Task: ${task[index]}", style: TextStyle(color: Colors.white)),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Text("Details: ${tdetail[index]}", style: TextStyle(color: Colors.white)),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Text("Ends on: ${(date[index].day)}-${(date[index].month)}-${(date[index].year)} ${date[index].hour}:${date[index].minute}", style: TextStyle(color: Colors.white)),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Text("Assigned by: ${assignee[index]}", style: TextStyle(color: Colors.white)),
                                                                                ),

                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: TextButton(
                                                                                      onPressed: () {
                                                                                        _launchmeet("https://${meetl[index]}");
                                                                                      },
                                                                                      child: Text("Meet Link: ${(meetl[index])}")),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          actions: <
                                                                              Widget>[
                                                                            TextButton(
                                                                              child: const Text('Accept'),
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                            ),
                                                                          ],
                                                                          elevation:
                                                                          24,
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                  icon: Icon(
                                                                    Icons
                                                                        .remove_red_eye,
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                              IconButton(onPressed: (){
                                                                if(DateTime.now().difference(date[index]).inDays>90){
                                                                  firestoreInstance.collection("Users").doc('$uid').collection('Task').doc('${date[index]}').delete();
                                                                }
                                                                else{
                                                                  showDialog(context: context, builder: (BuildContext bs){
                                                                    return AlertDialog(title: Text("Task can only be deleted after 90 Days since End Date"),);
                                                                  });
                                                                }
                                                              }, icon: Icon(Icons.delete,color: Colors.white,)),
                                                            ],
                                                          ),
                                                        ),
                                                        //Text("${Status[index]}"),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {},

                                          //
                                        ),
                                      );
                                    } else {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 5,),
                                          /*Center(
                                              child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 200, 8, 8),
                                            child: Image(
                                              image: AssetImage("assets/2.png"),
                                              height: 150,
                                              width: 200,
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                              colorBlendMode:
                                                  BlendMode.modulate,
                                            ),
                                          )),
                                          Text(
                                            "History Cleared",
                                            style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.7),
                                                fontSize: 22),
                                          ),*/
                                        ],
                                      );
                                    }
                                  }):Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Center(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 8, 8, 8),
                                        child: Image(
                                          image: AssetImage("assets/2.png"),
                                          height: 150,
                                          width: 200,
                                          color:
                                          Colors.white.withOpacity(0.5),
                                          colorBlendMode:
                                          BlendMode.modulate,
                                        ),
                                      )),
                                  Text(
                                    "History Cleared",
                                    style: TextStyle(
                                        color: Colors.white
                                            .withOpacity(0.7),
                                        fontSize: 22),
                                  ),
                                ],
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
          floatingActionButton: FloatingActionButton(
            //Floating action button on Scaffold

            onPressed: () {
              setState(() {
                meet = "null";
              });
              showDialog<void>(
                context: context,
                barrierDismissible: true, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0)),
                    backgroundColor: Color.fromARGB(255, 48, 48, 54),
                    title: Padding(
                      padding: EdgeInsets.only(left: 10, top: 10),
                      child: const Text(
                        'Create Task',
                        style: TextStyle(color: Colors.white, fontSize: 28),
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: Material(
                        child: Container(
                          color: Color.fromARGB(255, 48, 48, 54),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5)),
                                  width: 350,
                                  height: 50,
                                  padding: EdgeInsets.only(left: 4),
                                  child: TextFormField(
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Title here(<25 chars)",
                                        hintStyle:
                                            TextStyle(color: Colors.grey)),
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: false,
                                    onChanged: (value) {
                                      Task = value;
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5)),
                                  width: 350,
                                  height: 50,
                                  padding: EdgeInsets.only(left: 4),
                                  child: TextFormField(
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Details here/Event Name",
                                        hintStyle:
                                            TextStyle(color: Colors.grey)),
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: false,
                                    onChanged: (value) {
                                      tdet = value;
                                    },
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  MaterialButton(
                                    onPressed: () {
                                      _selectDateTime(context);
                                    },
                                    color: Colors.blue[900],
                                    child: Text(
                                      "End Date & Time",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Text(
                                "Set Priority",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              StatefulBuilder(
                                builder: (context, setState) => Slider(
                                  value: _priority,
                                  max: 9,
                                  divisions: 9,
                                  label:
                                      "Priority:${(_priority + 1).round().toString()}",
                                  onChanged: (double value) {
                                    // print("$value");
                                    setState(() {
                                      _priority = value;
                                    });
                                    //print(_priority.round());
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        color: Colors.white,
                                        icon: const Icon(Icons.person_add),
                                        tooltip: 'Add collaborators',
                                        onPressed: () {
                                          refreshUser();
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext bc) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      TextField(
                                                        onChanged: (value) =>
                                                            _runFilter(value),
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'Search',
                                                                suffixIcon:
                                                                    Icon(Icons
                                                                        .search)),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Expanded(
                                                        child: _foundUsers
                                                                .isNotEmpty
                                                            ? RefreshIndicator(
                                                                onRefresh:
                                                                    refreshList,
                                                                backgroundColor:
                                                                    Colors.blue[
                                                                        900],
                                                                color: Colors
                                                                    .white,
                                                                child: StreamBuilder<
                                                                        QuerySnapshot>(
                                                                    stream: firestoreInstance
                                                                        .collection(
                                                                            'Users')
                                                                        .snapshots(),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      return ListView
                                                                          .builder(
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount:
                                                                            _foundUsers.length,
                                                                        itemBuilder:
                                                                            (context, index) =>
                                                                                Card(
                                                                          key: ValueKey(_foundUsers[index]
                                                                              [
                                                                              "id"]),
                                                                          color:
                                                                              Colors.grey,
                                                                          elevation:
                                                                              4,
                                                                          margin:
                                                                              const EdgeInsets.symmetric(vertical: 10),
                                                                          child:
                                                                              ListTile(
                                                                            leading:
                                                                                IconButton(
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  all = all + 1;
                                                                                  if (_priority.toInt() >= 0 && _priority.toInt() < 4) {
                                                                                    setState(() {
                                                                                      priority = "green";
                                                                                    });
                                                                                  } else if (_priority.toInt() >= 4 && _priority.toInt() <= 7) {
                                                                                    setState(() {
                                                                                      priority = "yellow";
                                                                                    });
                                                                                  } else {
                                                                                    setState(() {
                                                                                      priority = "red";
                                                                                    });
                                                                                  }
                                                                                });

                                                                                firestoreInstance.collection("Users").doc('${_foundUsers[index]["id"]}').collection('Task').doc('$dateTime').set({
                                                                                  'Task': Task,
                                                                                  'Date': dateTime,
                                                                                  'Priority': priority,
                                                                                  'status': false,
                                                                                  'assignee':_auth.currentUser?.displayName,
                                                                                  'sdate': _sdate,
                                                                                  'meet': meet,
                                                                                  'Details': tdet,
                                                                                });
                                                                                showDialog(
                                                                                    context: context,
                                                                                    barrierDismissible: true,
                                                                                    builder: (BuildContext bs) {
                                                                                      return AlertDialog(
                                                                                        backgroundColor: Color.fromARGB(255, 56, 52, 52),
                                                                                        title: Text("Task Assigned to ${_foundUsers[index]['username']}", style: TextStyle(color: Colors.white)),
                                                                                      );
                                                                                    });
                                                                                _launcchat("https://wa.me/${_foundUsers[index]['phone']}?text=Task: ${Task} assigned to you by ${_auth.currentUser?.displayName}, check your app for new tasks");
                                                                              },
                                                                              icon: Icon(Icons.add),
                                                                            ),
                                                                            title:
                                                                                Text(_foundUsers[index]['username']),
                                                                            subtitle:
                                                                                Text('${_foundUsers[index]["desig"]}'),
                                                                            trailing:
                                                                                IconButton(
                                                                              icon: Icon(
                                                                                Icons.chat,
                                                                                color: Colors.white,
                                                                              ),
                                                                              onPressed: () {
                                                                                _launcchat("https://wa.me/${_foundUsers[index]['phone']}?text=Please check your app for new tasks");
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }),
                                                              )
                                                            : const Text(
                                                                'No results found',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        24),
                                                              ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                      ),
                                      Text('Collaborate',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ))
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        color: Colors.white,
                                        icon: const Icon(Icons.calendar_today),
                                        tooltip: 'Add meet',
                                        onPressed: () {
                                          _launchInWebViewOrVC(_url);
                                        },
                                      ),
                                      Text('Meeting',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5)),
                                  width: 350,
                                  height: 50,
                                  padding: EdgeInsets.only(left: 4),
                                  child: TextFormField(
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Paste meet link here",
                                        hintStyle:
                                            TextStyle(color: Colors.grey)),
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: false,
                                    onChanged: (value) {
                                      meet = value;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 30, right: 15),
                        child: MaterialButton(
                          onPressed: () {
                            if (Task.isNotEmpty &&
                                Task.length.toInt() < 25 &&
                                dateTime
                                        .difference(DateTime.now())
                                        .isNegative !=
                                    true) {
                              showNotification();
                              setState(() {
                                all = all + 1;
                                if (_priority.toInt() >= 0 &&
                                    _priority.toInt() < 4) {
                                  setState(() {
                                    priority = "green";
                                  });
                                } else if (_priority.toInt() >= 4 &&
                                    _priority.toInt() <= 7) {
                                  setState(() {
                                    priority = "yellow";
                                  });
                                } else {
                                  setState(() {
                                    priority = "red";
                                  });
                                }
                              });

                              firestoreInstance
                                  .collection("Users")
                                  .doc('$uid')
                                  .collection('Task')
                                  .doc('$dateTime')
                                  .set({
                                'Task': Task,
                                'Details': tdet,
                                'Date': dateTime,
                                'Priority': priority,
                                'status': false,
                                'assignee':_auth.currentUser?.displayName,
                                'sdate': _sdate,
                                'meet': meet,
                              });
                              firestoreInstance
                                  .collection("$uid")
                                  .doc("Data")
                                  .update({'number': all});
                              refreshList();
                              Navigator.pop(context);
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext bs) {
                                    return AlertDialog(
                                      backgroundColor:
                                          Color.fromARGB(255, 56, 52, 52),
                                      title: Text(
                                          "Title and New date time needed or Title length to be less than 25 charachters",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    );
                                  });
                            }
                          },
                          color: Colors.blue[900],
                          child: Text(
                            "Create",
                            style: TextStyle(color: Colors.white),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                      ),
                    ],
                    elevation: 24,
                  );
                },
              );
            },
            backgroundColor: Colors.blue[900],
            child: Icon(Icons.add), //icon inside button
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
              //bottom navigation bar on scaffold
              color: Color.fromARGB(255, 83, 82, 82),
              shape: CircularNotchedRectangle(), //shape of notch
              notchMargin:
                  5, //notch margin between floating button and bottom appbar
              child: Container(
                height: height(0.078),
                child: Row(
                  //children inside bottom appbar
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/profile2');
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/calendar');
                      },
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.chat,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/chat');
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.stream,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/event');
                      },
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
