import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class event extends StatefulWidget {
  const event({Key? key}) : super(key: key);

  @override
  State<event> createState() => _eventState();
}

class _eventState extends State<event> {
  final firestoreInstance = FirebaseFirestore.instance;
  @override
  bool _passwordVisible = true;
  String username = "";
  String pass = "";
  String name = "";
  String dropdownValue = "Select Department";
  String dropdownValue1 = "Select Paid/UnPaid";
  String Coordinator = "";
  String Description = "";
  List<String> ename = [];
  List<String> deptname = [];
  List<String> paid = [];
  List<String> ecoord = [];
  List<String> edesc = [];
  List<DateTime> edate = [];
  bool auth = false;
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime today = DateTime.now();
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

  Future<void> getdat() async {
    firestoreInstance.collection('Events').snapshots().listen((event) {
      for (var i in event.docs) {
        //print(i.get('Name'));
        ename.add(i.get('Name'));
        deptname.add(i.get('Department'));
        ecoord.add(i.get('coordinator'));
        Timestamp timestamp = i.get('date');
        var result = DateTime.fromMicrosecondsSinceEpoch(
            timestamp.microsecondsSinceEpoch);
        edate.add(result);
        edesc.add(i.get('Details'));
        paid.add(i.get('paid'));
      }
    });
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    ename.clear();
    deptname.clear();
    paid.clear();
    ecoord.clear();
    edesc.clear();
    edate.clear();
    await Future.delayed(Duration(seconds: 1));
    getdat();
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    today = DateTime.now();
    getdat();
    setState(() {
      auth = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 27, 33, 41),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text("Events"),
            bottom: const TabBar(
              tabs: [
                Tab(
                  child: Text("Up Next"),
                ),
                Tab(
                  child: Text("Old Stuff"),
                ),
                Tab(
                  child: Text("All"),
                ),
              ],
              indicatorColor: Colors.white,
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    if (auth != true) {
                      showDialog(
                          context: context,
                          builder: (BuildContext bc) {
                            return AlertDialog(
                              title: const Text('Authentication'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text(
                                        "Authenticate yourself to edit or create event"),
                                    Padding(padding: EdgeInsets.only(top: 20)),
                                    Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      padding: EdgeInsets.only(left: 4),
                                      child: TextFormField(
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black),
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Enter Your Username",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[700])),
                                        onChanged: (value) {
                                          username = value;
                                        },
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 10)),
                                    Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      padding: EdgeInsets.only(left: 4),
                                      child: TextFormField(
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Password",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[700]),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              // Based on passwordVisible state choose the icon
                                              _passwordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.black,
                                            ),
                                            onPressed: () {
                                              // Update the state i.e. toogle the state of passwordVisible variable
                                              setState(() {
                                                _passwordVisible =
                                                    !_passwordVisible;
                                              });
                                            },
                                          ),
                                        ),
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        obscureText: !_passwordVisible,
                                        obscuringCharacter: '*',
                                        onChanged: (value) {
                                          pass = value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Proceed'),
                                  onPressed: () {
                                    if (username == "Admin" &&
                                        pass == "MSCdev!") {
                                      setState(() {
                                        auth = true;
                                      });
                                      Navigator.of(context).pop();
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.white,
                                          builder: (BuildContext bs) {
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  "Enter Event Details",
                                                  style: TextStyle(
                                                      color: Colors.teal,
                                                      fontSize: 18),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                  padding:
                                                      EdgeInsets.only(left: 4),
                                                  child: TextFormField(
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black),
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            "Enter Event name",
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[700])),
                                                    onChanged: (value) {
                                                      name = value;
                                                    },
                                                  ),
                                                ),
                                                DropdownButton(
                                                  dropdownColor: Colors.white,
                                                  value: dropdownValue,
                                                  icon: const Icon(Icons
                                                      .keyboard_arrow_down),
                                                  iconSize: 24,
                                                  elevation: 16,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                  underline: Container(
                                                    height: 2,
                                                    color: Colors.blueGrey,
                                                  ),
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      dropdownValue = newValue!;
                                                    });
                                                  },
                                                  items: <String>[
                                                    'Select Department',
                                                    'Graphic Design',
                                                    'Content',
                                                    'Video Editing',
                                                    'Operations',
                                                    'KIIT BUZZ',
                                                    'Corporate Relations&Marketing',
                                                    'Web Development',
                                                    'Machine Learning',
                                                    'App Development',
                                                    'Cloud',
                                                    'Cyber Security',
                                                    'AR/VR',
                                                    'UI/UX'
                                                  ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Colors.blueGrey,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                  padding:
                                                      EdgeInsets.only(left: 4),
                                                  child: TextFormField(
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black),
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            "Enter Co-Ordinator name",
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[700])),
                                                    onChanged: (value) {
                                                      Coordinator = value;
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                  padding:
                                                      EdgeInsets.only(left: 4),
                                                  child: TextFormField(
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black),
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            "Enter Event Details here",
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[700])),
                                                    onChanged: (value) {
                                                      Description = value;
                                                    },
                                                  ),
                                                ),
                                                DropdownButton(
                                                  dropdownColor: Colors.white,
                                                  value: dropdownValue1,
                                                  icon: const Icon(Icons
                                                      .keyboard_arrow_down),
                                                  iconSize: 24,
                                                  elevation: 16,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  underline: Container(
                                                    height: 2,
                                                    color: Colors.blueGrey,
                                                  ),
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      dropdownValue1 =
                                                          newValue!;
                                                    });
                                                  },
                                                  items: <String>[
                                                    'Select Paid/UnPaid',
                                                    'Paid Event',
                                                    'UnPaid Event'
                                                  ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Colors.blueGrey,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: MaterialButton(
                                                        onPressed: () {
                                                          _selectDateTime(
                                                              context);
                                                        },
                                                        color: Colors.blue[900],
                                                        child: Text(
                                                          "Date&Time",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0)),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: MaterialButton(
                                                        onPressed: () {
                                                          firestoreInstance
                                                              .collection(
                                                                  'Events')
                                                              .doc('$dateTime')
                                                              .set({
                                                            'Name': name,
                                                            'Department':
                                                                dropdownValue,
                                                            'coordinator':
                                                                Coordinator,
                                                            'Details':
                                                                Description,
                                                            'paid':
                                                                dropdownValue1,
                                                            'date': dateTime,
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        color: Colors.blue[900],
                                                        child: Text(
                                                          "Create",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          });
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext bs) {
                                            return AlertDialog(
                                              title: Text("Wrong credentials"),
                                            );
                                          });
                                    }
                                  },
                                ),
                              ],
                              elevation: 24,
                            );
                          });
                    } else {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          builder: (BuildContext bs) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Enter Event Details",
                                  style: TextStyle(
                                      color: Colors.teal, fontSize: 18),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(5)),
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  padding: EdgeInsets.only(left: 4),
                                  child: TextFormField(
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Enter Event name",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[700])),
                                    onChanged: (value) {
                                      name = value;
                                    },
                                  ),
                                ),
                                DropdownButton(
                                  dropdownColor: Colors.white,
                                  value: dropdownValue,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.white),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.blueGrey,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    'Select Department',
                                    'MSC KIIT',
                                    'Graphic Design',
                                    'Content',
                                    'Video Editing',
                                    'Operations',
                                    'KIIT BUZZ',
                                    'Corporate Relations&Marketing',
                                    'Web Development',
                                    'Machine Learning',
                                    'App Development',
                                    'Cloud',
                                    'Cyber Security',
                                    'AR/VR',
                                    'UI/UX'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(5)),
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  padding: EdgeInsets.only(left: 4),
                                  child: TextFormField(
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Enter Co-Ordinator name",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[700])),
                                    onChanged: (value) {
                                      Coordinator = value;
                                    },
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(5)),
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  padding: EdgeInsets.only(left: 4),
                                  child: TextFormField(
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Enter Event Details here",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[700])),
                                    onChanged: (value) {
                                      Description = value;
                                    },
                                  ),
                                ),
                                DropdownButton(
                                  dropdownColor: Colors.white,
                                  value: dropdownValue1,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.white),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.blueGrey,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue1 = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    'Select Paid/UnPaid',
                                    'Paid Event',
                                    'UnPaid Event'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: MaterialButton(
                                        onPressed: () {
                                          _selectDateTime(context);
                                        },
                                        color: Colors.blue[900],
                                        child: Text(
                                          "Date&Time",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: MaterialButton(
                                        onPressed: () {
                                          firestoreInstance
                                              .collection('Events')
                                              .doc('$dateTime')
                                              .set({
                                            'Name': name,
                                            'Department': dropdownValue,
                                            'coordinator': Coordinator,
                                            'Details': Description,
                                            'paid': dropdownValue1,
                                            'date': dateTime,
                                          });
                                          Navigator.pop(context);
                                        },
                                        color: Colors.blue[900],
                                        child: Text(
                                          "Create",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          });
                    }
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RefreshIndicator(
                      onRefresh: refreshList,
                      backgroundColor: Colors.blue,
                      color: Colors.white,
                      child: SizedBox(
                        height: 700,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: firestoreInstance
                                .collection('Events')
                                .snapshots(),
                            builder: (context, snapshot) {
                              return ListView.builder(
                                  itemCount: edate.isEmpty ? edate.length : 1,
                                  itemBuilder: (context, int index) {
                                    if (edate[index]
                                            .difference(today)
                                            .isNegative !=
                                        true) {
                                      return Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: SizedBox(
                                            height: 100,
                                            width: 70,
                                            child: Card(
                                                color: Color.fromRGBO(238, 187, 195, 1),
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext bs) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "Event Details"),
                                                            content: SizedBox(
                                                              height: 400,
                                                              width: 350,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text(
                                                                    "Event Name: ${ename[index]}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  Text(
                                                                    "Department Name: ${deptname[index]}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  Text(
                                                                    "Coordinator Name: ${ecoord[index]}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  Text(
                                                                    "Details: ${edesc[index]}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  Text(
                                                                    "Payment: ${paid[index]}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  Text(
                                                                    "Event Date: ${edate[index]}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Text(
                                                        "${ename[index]}",
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Text(
                                                        "${edate[index].year}-${edate[index].month}-${edate[index].day} ${edate[index].hour}:${edate[index].minute}",
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                ))),
                                      );
                                    } else {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Center(
                                            child: Text(
                                          "No Data to show",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 28),
                                        )),
                                      );
                                    }
                                  });
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RefreshIndicator(
                      onRefresh: refreshList,
                      backgroundColor: Colors.purple,
                      color: Colors.white,
                      child: SizedBox(
                        height: 700,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: firestoreInstance
                                .collection('Events')
                                .snapshots(),
                            builder: (context, snapshot) {
                              return ListView.builder(
                                  itemCount: edate.isEmpty ? edate.length : 1,
                                  itemBuilder: (context, int index) {
                                    if (edate[index]
                                            .difference(today)
                                            .isNegative ==
                                        true) {
                                      return Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: SizedBox(
                                            height: 100,
                                            width: 70,
                                            child: Card(
                                                color: Color.fromRGBO(238, 187, 195, 1),
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext bs) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "Event Details"),
                                                            content: SizedBox(
                                                              height: 400,
                                                              width: 350,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text(
                                                                    "Event Name: ${ename[index]}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  Text(
                                                                    "Department Name: ${deptname[index]}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  Text(
                                                                    "Coordinator Name: ${ecoord[index]}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  Text(
                                                                    "Details: ${edesc[index]}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  Text(
                                                                    "Payment: ${paid[index]}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  Text(
                                                                    "Event Date: ${edate[index]}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Text(
                                                        "${ename[index]}",
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Text(
                                                        "${edate[index].year}-${edate[index].month}-${edate[index].day} ${edate[index].hour}:${edate[index].minute}",
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                ))),
                                      );
                                    } else {
                                      return Column(mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Center(
                                                child: Text(
                                              "All Clear Captain",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 32),
                                            )),
                                          ),
                                        ],
                                      );
                                    }
                                  });
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RefreshIndicator(
                      onRefresh: refreshList,
                      backgroundColor: Colors.purple,
                      color: Colors.white,
                      child: SizedBox(
                        height: 700,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: firestoreInstance
                                .collection('Events')
                                .snapshots(),
                            builder: (context, snapshot) {
                              return ListView.builder(
                                  itemCount: edate.isEmpty ? edate.length : 1,
                                  itemBuilder: (context, int index) {
                                    if (ename[index].isEmpty != true) {
                                      return Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: SizedBox(
                                            height: 100,
                                            width: 70,
                                            child: Card(
                                                color: Color.fromRGBO(238, 187, 195, 1),
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext bs) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "Event Details"),
                                                            content: SizedBox(
                                                              height: 400,
                                                              width: 350,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text(
                                                                    "Event Name: ${ename[index]}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  Text(
                                                                    "Department Name: ${deptname[index]}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  Text(
                                                                    "Coordinator Name: ${ecoord[index]}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  Text(
                                                                    "Details: ${edesc[index]}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  Text(
                                                                    "Payment: ${paid[index]}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  Text(
                                                                    "Event Date: ${edate[index]}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Text(
                                                        "${ename[index]}",
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Text(
                                                        "${edate[index].year}-${edate[index].month}-${edate[index].day} ${edate[index].hour}:${edate[index].minute}",
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                ))),
                                      );
                                    } else {
                                      return Column(mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Center(
                                              child: Text(
                                            "no Data to show",
                                            style: TextStyle(color: Colors.white),
                                          )),
                                        ],
                                      );
                                    }
                                  });
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
