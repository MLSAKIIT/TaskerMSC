// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, camel_case_types

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:url_launcher/url_launcher.dart';

class calendar extends StatefulWidget {
  const calendar({Key? key}) : super(key: key);

  @override
  State<calendar> createState() => _calendarState();
}

DateTime get _now => DateTime.now();

class _calendarState extends State<calendar> {
  final _auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  String username = "";
  String uid = "";
  String Task = "";
  String priority = "";
  String meet="";
  String tdet="";
  bool mcreate=false;
  double _priority = 0;
  CalendarController _controller = CalendarController();
  String? _text = '', _titleText = '';
  Color? _headerColor, _viewHeaderColor, _calendarColor;
  DateTime _sdate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  int all = 0;
  List<DateTime> date = [];
  List<String> task = [];
  //List <String> priority=[];
  List<bool> Status = [];
  List pcol1 = [];
  List<String> uids = [];
  List<String> users = [];
  List<String> udesig = [];
  List<String>meetl=[];
  List<String>tdetail=[];
  List<String>assignee=[];
  List<String> uno = [];
  List<Map<String, dynamic>> _foundUsers = [];
  List<Map<String, dynamic>> _Users = [];
  @override
  void initState() {
    super.initState();
    getdat();
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
            pcol1.add(Colors.green);
          });
        }
        if (prio == "yellow") {
          setState(() {
            pcol1.add(Colors.yellow);
          });
        }
        if (prio == "red") {
          setState(() {
            pcol1.add(Colors.red);
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
  Future<Null> refreshUser() async {
    await Future.delayed(Duration(seconds: 2));
    uids.clear();
    users.clear();
    udesig.clear();
    uno.clear();
    _Users.clear();
    await Future.delayed(Duration(seconds: 1));
    getdat();
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

  String etime="";
  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (selected != null && selected != selectedTime) {
      setState(() {
        selectedTime = selected;
        etime="${selectedTime.hour}:${selectedTime.minute}";
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
  void calendarTapped(CalendarTapDetails details) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          if (details.targetElement == CalendarElement.calendarCell) {
            _text = DateFormat('EEEE dd, MMMM yyyy')
                .format(details.date!)
                .toString();
          }
          return AlertDialog(
            title: Container(child: new Text(" $_text")),
            content: SingleChildScrollView(
              child: Container(
                height: 160,
                child: StreamBuilder<QuerySnapshot>(
                    stream: firestoreInstance
                        .collection("Users")
                        .doc('$uid')
                        .collection('Task')
                        .snapshots(),
                    builder: (context, snapshot) {
                      return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  childAspectRatio: 1 / 0.3,
                                  mainAxisSpacing: 10),
                          itemCount: task.length,
                          itemBuilder: (context, int index) {
                            if (task[0].isEmpty && Status[index]==true) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/logo.png'),
                                  ),
                                ),
                              );
                            } else {
                              return OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color: Colors.transparent, width: 1)),
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 20,
                                  margin: EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Container(
                                    width: width(1),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            pcol1[index],
                                            pcol1[index],
                                          ],
                                          // begin: Alignment.bottomRight,
                                          // end: Alignment.topCenter,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(top: 20)),
                                        Text(
                                          "    ${task[index].toUpperCase()}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: height(0.018),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "      ${(date[index])}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: height(0.016),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        //Text("${Status[index]}"),
                                      ],
                                    ),
                                  ),
                                ),

                                onPressed: () {
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

                                //
                              );
                            }
                          });
                    }),
              ),
            ),
            actions: <Widget>[
              new TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text('close'))
            ],
          );
        });
  }

  //Gives height and width according to screen size
  double height(double height) {
    return MediaQuery.of(context).size.height * height;
  }

  double width(double width) {
    return MediaQuery.of(context).size.width * width;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 27, 33, 41),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Your Tasks"),
          leading: IconButton(onPressed: (){Navigator.pop(context);},icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,),),
          centerTitle: true,
          elevation: 0,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    date.clear();
                    task.clear();
                    Status.clear();
                  });
                  getdat();
                  //Navigator.pushNamed(context,'/profile'),
                },
                child: Icon(Icons.refresh,color: Colors.white,),
              ),
            ),
          ],
        ),
        body: StreamBuilder<Object>(
            stream:
            firestoreInstance
                .collection("Users")
                .doc('$uid').collection('Task')
                .snapshots(),
            builder: (context, snapshot) {
              return SfCalendar(
                view: CalendarView.month,
                showCurrentTimeIndicator: true,
                showNavigationArrow: true,
                showDatePickerButton: true,
                minDate: DateTime.now(),
                dataSource: MeetingDataSource(_getDataSource()),
                backgroundColor: Colors.blueGrey.shade200,
                cellBorderColor: Colors.white,
                todayHighlightColor: Colors.orange,
                selectionDecoration:BoxDecoration(
                  color: Colors.transparent,
                  border:
                  Border.all(color: Colors.white,
                      width: 3),
                  borderRadius: const BorderRadius.all(Radius.circular(3)),
                  shape: BoxShape.rectangle,
                ),
                onTap: calendarTapped,
                monthViewSettings: MonthViewSettings(
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment),
              );
            }),
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
                                        _launchInWebViewOrVC("https://meet.google.com");
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
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    for (int i = 0; i < date.length; i++) {
      DateTime end = date[i];
      meetings.add(Meeting('${task[i]}', startTime, end, pcol1[i], Status[i]));
    }
    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
