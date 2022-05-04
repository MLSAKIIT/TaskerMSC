// ignore_for_file: prefer_const_constructors ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile2 extends StatefulWidget {
  const Profile2({Key? key}) : super(key: key);

  @override
  State<Profile2> createState() => _Profile2State();
}

enum ImageSourceType { gallery, camera }

class _Profile2State extends State<Profile2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdat();
  }

  final _auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  String username = "";
  String uid = "";
  String url = "";
  String url2 = "";
  String email = "";
  String pno = "";
  String dropdownValue = 'Select Dept';
  String desig="";
  double height(double height) {
    return MediaQuery.of(context).size.height * height;
  }

  double width(double width) {
    return MediaQuery.of(context).size.width * width;
  }
  Future<void> getdat() async {
    final newUser = _auth.currentUser;
    //print(newUser?.uid);
    uid = newUser!.uid;
    //print(uid);
    firestoreInstance
        .collection('Users')
        .doc('$uid').snapshots().listen((event) {
          username=event.get('username');
          pno=event.get('phone');
          desig=event.get('designation');
    });
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(255, 27, 33, 41),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      "Hi!",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        _auth.currentUser!.displayName.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                // ignore: prefer_const_literals_to_create_immutables
                children: [CircleAvatar(
                  backgroundImage: AssetImage(_auth.currentUser?.photoURL as String),
                  radius: 62,
                  backgroundColor: Colors.blueGrey,
                ),
                  Positioned(
                    left: 60,
                    bottom: 5,
                    child: RawMaterialButton(
                      child: Icon(Icons.create_rounded),
                      fillColor: Colors.blue,
                      shape: CircleBorder(),
                      onPressed: () {
                        showModalBottomSheet(context: context, builder: (BuildContext bc){
                          return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Select your Display Picture",style: TextStyle(color: Colors.teal,fontSize: 20),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    OutlinedButton(onPressed: (){
                                      _auth.currentUser?.updatePhotoURL("assets/male1.png");
                                      //Navigator.of(context).popAndPushNamed('/login');
                                      Navigator.pop(context);
                                      showDialog(context: context,builder: (BuildContext bc){
                                        return AlertDialog(
                                          title: const Text('DP will be updated on next Login'),
                                        );
                                      });
                                    },
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(width: 5.0,color: Colors.transparent)
                                      ),
                                      child: Column(
                                        children: [
                                          CircleAvatar(radius: 32,backgroundImage: AssetImage("assets/male1.png"),backgroundColor: Colors.blueGrey,),
                                          Text("Andy",style: TextStyle(color: Colors.orange,fontSize: 16),),
                                        ],
                                      ),
                                    ),OutlinedButton(onPressed: (){
                                      _auth.currentUser?.updatePhotoURL("assets/male2.png");
                                      //Navigator.of(context).popAndPushNamed('/login');
                                      Navigator.pop(context);
                                      showDialog(context: context,builder: (BuildContext bc){
                                        return AlertDialog(
                                          title: const Text('DP will be updated on next Login'),
                                        );
                                      });
                                    },
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(width: 5.0,color: Colors.transparent)
                                      ),
                                      child: Column(
                                        children: [
                                          CircleAvatar(radius: 32,backgroundImage: AssetImage("assets/male2.png"),backgroundColor: Colors.blueGrey,),
                                          Text("Mandy",style: TextStyle(color: Colors.pink,fontSize: 16),),
                                        ],
                                      ),
                                    ),OutlinedButton(onPressed: (){
                                      _auth.currentUser?.updatePhotoURL("assets/male3.png");
                                      //Navigator.of(context).popAndPushNamed('/login');
                                      Navigator.pop(context);
                                      showDialog(context: context,builder: (BuildContext bc){
                                        return AlertDialog(
                                          title: const Text('DP will be updated on next Login'),
                                        );
                                      });
                                    },
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(width: 5.0,color: Colors.transparent)
                                      ),
                                      child: Column(
                                        children: [
                                          CircleAvatar(radius: 32,backgroundImage: AssetImage("assets/male3.png"),backgroundColor: Colors.blueGrey,),
                                          Text("Sandy",style: TextStyle(color: Colors.brown,fontSize: 16),),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    OutlinedButton(onPressed: (){
                                      _auth.currentUser?.updatePhotoURL("assets/Female1.png");
                                      //Navigator.of(context).popAndPushNamed('/login');
                                      Navigator.pop(context);
                                      showDialog(context: context,builder: (BuildContext bc){
                                        return AlertDialog(
                                          title: const Text('DP will be updated on next Login'),
                                        );
                                      });
                                    },
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(width: 5.0,color: Colors.transparent)
                                      ),
                                      child: Column(
                                        children: [
                                          CircleAvatar(radius: 32,backgroundImage: AssetImage("assets/Female1.png"),backgroundColor: Colors.blueGrey,),
                                          Text("Alisha",style: TextStyle(color: Colors.orange,fontSize: 16),),
                                        ],
                                      ),
                                    ),OutlinedButton(onPressed: (){
                                      _auth.currentUser?.updatePhotoURL("assets/Female2.png");
                                      //Navigator.of(context).popAndPushNamed('/login');
                                      Navigator.pop(context);
                                      showDialog(context: context,builder: (BuildContext bc){
                                        return AlertDialog(
                                          title: const Text('DP will be updated on next Login'),
                                        );
                                      });
                                    },
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(width: 5.0,color: Colors.transparent)
                                      ),
                                      child: Column(
                                        children: [
                                          CircleAvatar(radius: 32,backgroundImage: AssetImage("assets/Female2.png"),backgroundColor: Colors.blueGrey,),
                                          Text("Nora",style: TextStyle(color: Colors.pink,fontSize: 16),),
                                        ],
                                      ),
                                    ),OutlinedButton(onPressed: (){
                                      _auth.currentUser?.updatePhotoURL("assets/Female3.png");
                                      //Navigator.of(context).popAndPushNamed('/login');
                                      Navigator.pop(context);
                                      showDialog(context: context,builder: (BuildContext bc){
                                        return AlertDialog(
                                          title: const Text('DP will be updated on next Login'),
                                        );
                                      });
                                    },
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(width: 5.0,color: Colors.transparent)
                                      ),
                                      child: Column(
                                        children: [
                                          CircleAvatar(radius: 32,backgroundImage: AssetImage("assets/Female3.png"),backgroundColor: Colors.blueGrey,),
                                          Text("Candice",style: TextStyle(color: Colors.brown,fontSize: 16),),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(
            color: Colors.grey,
            height: 40,
            thickness: 2,
          ),
          SingleChildScrollView(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestoreInstance.collection('Users').snapshots(),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 10,),
                        Container(
                            padding: EdgeInsets.only(top: 30),
                            child: Text("Email:",
                                style: TextStyle(
                                    fontSize:
                                    MediaQuery.of(context).size.height * 0.024,
                                    color: Colors.white))),
                      ],
                    ),

                Row(
                  children: [
                    SizedBox(width: 10,),
                    Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Text("${_auth.currentUser?.email}",
                            style: TextStyle(
                                fontSize:
                                MediaQuery.of(context).size.height * 0.021,
                                color: Colors.white))),
                    IconButton(onPressed: (){
                      showDialog(context: context, builder: (BuildContext bc){
                        return AlertDialog(
                          title: Text("Edit",style: TextStyle(color: Colors.teal,fontSize: 18)),
                          content: Container(height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(5)),
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  padding: EdgeInsets.only(left: 4),
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 18, color: Colors.black),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Email",
                                        hintStyle: TextStyle(color: Colors.grey[700])),
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: (value) {
                                      email = value;
                                    },
                                  ),
                                ),
                                MaterialButton(onPressed: (){
                                  _auth.currentUser?.updateEmail(email);
                                  _auth.currentUser?.sendEmailVerification();
                                  Navigator.pop(context);
                                },color: Colors.teal,child: Text("Submit"),),
                              ],
                            ),
                          ),
                        );
                      });
                    }, icon: Icon(Icons.edit,color: Colors.white,))
                  ],
                ),Row(
                  children: [
                    SizedBox(width: 10,),
                    Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Text("Username:",
                            style: TextStyle(
                                fontSize:
                                MediaQuery.of(context).size.height * 0.024,
                                color: Colors.white))),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 10,),
                    Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Text("$username",
                            style: TextStyle(
                                fontSize:
                                MediaQuery.of(context).size.height * 0.021,
                                color: Colors.white))),
                    IconButton(onPressed: (){
                      showDialog(context: context, builder: (BuildContext bc){
                        return AlertDialog(
                          title: Text("Edit",style: TextStyle(color: Colors.teal,fontSize: 18)),
                          content: Container(height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(5)),
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  padding: EdgeInsets.only(left: 4),
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 18, color: Colors.black),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Username",
                                        hintStyle: TextStyle(color: Colors.grey[700])),
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: (value) {
                                      username = value;
                                    },
                                  ),
                                ),
                                MaterialButton(onPressed: (){
                                  _auth.currentUser?.updateDisplayName(username);
                                  firestoreInstance.collection("Users").doc("$uid").update(
                                      {
                                        'username':username,
                                      });
                                  Navigator.pop(context);
                                },color: Colors.teal,child: Text("Submit"),),
                              ],
                            ),
                          ),
                        );
                      });
                    }, icon: Icon(Icons.edit,color: Colors.white,))
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 10,),
                    Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Text("Department:",
                            style: TextStyle(
                                fontSize:
                                MediaQuery.of(context).size.height * 0.024,
                                color: Colors.white))),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 10,),
                    Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Text("$desig",
                            style: TextStyle(
                                fontSize:
                                MediaQuery.of(context).size.height * 0.021,
                                color: Colors.white))),
                    IconButton(onPressed: (){
                      showDialog(context: context, builder: (BuildContext bc){
                        return AlertDialog(backgroundColor: Colors.blueGrey,
                          title: Text("Edit",style: TextStyle(color: Colors.tealAccent,fontSize: 18)),
                          content: Container(height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                DropdownButton(
                                  dropdownColor: Colors.teal,
                                  value: dropdownValue,
                                  icon: const Icon(Icons.keyboard_arrow_down,color: Colors.white,),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.white),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.white,
                                  ),
                                  onChanged: (String? newValue){
                                    setState(() {
                                      dropdownValue=newValue!;
                                    });
                                  },
                                  items: <String>['Select Dept','Graphic Design','Content','Video Editing','Operations','KIIT BUZZ','CR&Mkt.','Web Dev','M L','App Dev','Cloud','Cyber Sec','AR/VR','UI/UX']
                                      .map<DropdownMenuItem<String>>((String value){
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),),
                                    );
                                  }).toList(),

                                ),
                                MaterialButton(onPressed: (){
                                  firestoreInstance.collection("Users").doc("$uid").update(
                                      {
                                        'designation':dropdownValue,
                                      });
                                  Navigator.pop(context);
                                },color: Colors.teal,child: Text("Submit"),),
                              ],
                            ),
                          ),
                        );
                      });
                    }, icon: Icon(Icons.edit,color: Colors.white,))
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 10,),
                    Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Text("Phone:",
                            style: TextStyle(
                                fontSize:
                                MediaQuery.of(context).size.height * 0.024,
                                color: Colors.white))),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 10,),
                    Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Text("$pno",
                            style: TextStyle(
                                fontSize:
                                MediaQuery.of(context).size.height * 0.021,
                                color: Colors.white))),
                    IconButton(onPressed: (){
                      showDialog(context: context, builder: (BuildContext bc){
                        return AlertDialog(
                          title: Text("Edit",style: TextStyle(color: Colors.teal,fontSize: 18)),
                          content: Container(height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(5)),
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  padding: EdgeInsets.only(left: 4),
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 18, color: Colors.black),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Phone",
                                        hintStyle: TextStyle(color: Colors.grey[700])),
                                    keyboardType: TextInputType.phone,
                                    onChanged: (value) {
                                      pno = value;
                                    },
                                  ),
                                ),
                                MaterialButton(onPressed: (){
                                  firestoreInstance.collection("Users").doc("$uid").update(
                                      {
                                        'phone':pno,
                                      });
                                  Navigator.pop(context);
                                },color: Colors.teal,child: Text("Submit"),),
                              ],
                            ),
                          ),
                        );
                      });
                    }, icon: Icon(Icons.edit,color: Colors.white,))
                  ],
                ),
                  ],
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
