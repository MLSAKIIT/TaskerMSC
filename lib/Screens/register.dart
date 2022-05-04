// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  bool _passwordVisible = true;
  String email = "";
  String pass = "";
  String _prefix = '+91';
  String username = "";
  String pno = "";
  String dropdownValue = 'Select Department';
  String uid = "";
  String designation = "";
  @override
  /*Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }*/

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Color.fromARGB(255, 20, 24, 30),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.12),
                    child: Text(
                      "Register",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 30),
                      child: Text("Email",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.026,
                              color: Colors.white))),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(5)),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.06,
                    padding: EdgeInsets.only(left: 4),
                    child: TextFormField(
                      style: TextStyle(fontSize: 18, color: Colors.white),
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
                  Container(
                    padding: EdgeInsets.only(top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Username",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.026,
                                color: Colors.white)),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(5)),
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.06,
                          padding: EdgeInsets.only(left: 4),
                          child: TextFormField(
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter Your Username",
                                hintStyle: TextStyle(color: Colors.grey[700])),
                            onChanged: (value) {
                              username = value;
                            },
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 40)),
                        Text("Password",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.026,
                                color: Colors.white)),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(5)),
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.06,
                          padding: EdgeInsets.only(left: 4),
                          child: TextFormField(
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey[700]),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: !_passwordVisible,
                            onChanged: (value) {
                              pass = value;
                            },
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 40)),
                        Text("WhatsApp Number",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.026,
                                color: Colors.white)),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(5)),
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.06,
                          padding: EdgeInsets.only(left: 4),
                          child: TextFormField(
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Number here",
                              hintStyle: TextStyle(color: Colors.grey[700]),
                              prefixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    '+91',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                            ),
                            onChanged: (value){
                              pno="${_prefix}${value}";
                            },
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 30)),
                        DropdownButton(
                          dropdownColor: Colors.teal,
                          value: dropdownValue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.white),
                          underline: Container(
                            height: 2,
                            color: Colors.white,
                          ),
                          onChanged: (String? newValue) {
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
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        Padding(padding: EdgeInsets.only(top: 40)),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.062,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(border: Border.all()),
                          //color: Colors.blue[900],
                          child: MaterialButton(
                            onPressed: () async {
                              try {
                                final newUser =
                                    await _auth.createUserWithEmailAndPassword(
                                        email: email, password: pass);
                                if (newUser != null) {
                                  //print("Registered");
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor:
                                            Color.fromARGB(255, 56, 52, 52),
                                        title: const Text('User Registered',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: const <Widget>[
                                              Text(
                                                  'Click proceed to update username and receive verification mail',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Proceed'),
                                            onPressed: () async {
                                              final newUser =
                                                  await _auth.currentUser;
                                              uid = newUser!.uid;
                                              await newUser
                                                  .sendEmailVerification();
                                              firestoreInstance
                                                  .collection('Users')
                                                  .doc('$uid')
                                                  .set({
                                                'username': username,
                                                'status': false,
                                                'number': 0,
                                                'phone': pno,
                                                'designation': dropdownValue,
                                                'photourl': "",
                                              });
                                              _auth.currentUser
                                                  ?.updateDisplayName(username);
                                              showModalBottomSheet(
                                                isDismissible: false,
                                                  context: context,
                                                  builder: (BuildContext bc) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                              begin: Alignment
                                                                  .topLeft,
                                                              end: Alignment
                                                                  .bottomRight,
                                                              colors: [
                                                            Colors.black,
                                                            Colors.black,
                                                            Color.fromRGBO(
                                                                99, 108, 108, 1)
                                                          ])),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              "Select your Display Picture",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .teal,
                                                                  fontSize: 30),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                OutlinedButton(
                                                                  onPressed:
                                                                      () {
                                                                    _auth
                                                                        .currentUser
                                                                        ?.updatePhotoURL(
                                                                            "assets/male1.png");
                                                                    Navigator.of(
                                                                            context)
                                                                        .popAndPushNamed(
                                                                            '/login');
                                                                    firestoreInstance
                                                                        .collection(
                                                                            'Users')
                                                                        .doc(
                                                                            '$uid')
                                                                        .update({
                                                                      'photourl':
                                                                          "assets/male1.png",
                                                                    });
                                                                  },
                                                                  style: OutlinedButton.styleFrom(
                                                                      side: BorderSide(
                                                                          width:
                                                                              5.0,
                                                                          color:
                                                                              Colors.transparent)),
                                                                  child: Column(
                                                                    children: [
                                                                      CircleAvatar(
                                                                        radius:
                                                                            32,
                                                                        backgroundImage:
                                                                            AssetImage("assets/male1.png"),
                                                                        backgroundColor:
                                                                            Colors.blueGrey,
                                                                      ),
                                                                      Text(
                                                                        "Andy",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.orange,
                                                                            fontSize: 16),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                OutlinedButton(
                                                                  onPressed:
                                                                      () {
                                                                    _auth
                                                                        .currentUser
                                                                        ?.updatePhotoURL(
                                                                            "assets/male2.png");
                                                                    Navigator.of(
                                                                            context)
                                                                        .popAndPushNamed(
                                                                            '/login');
                                                                    firestoreInstance
                                                                        .collection(
                                                                            'Users')
                                                                        .doc(
                                                                            '$uid')
                                                                        .update({
                                                                      'photourl':
                                                                          "assets/male2.png",
                                                                    });
                                                                  },
                                                                  style: OutlinedButton.styleFrom(
                                                                      side: BorderSide(
                                                                          width:
                                                                              5.0,
                                                                          color:
                                                                              Colors.transparent)),
                                                                  child: Column(
                                                                    children: [
                                                                      CircleAvatar(
                                                                        radius:
                                                                            32,
                                                                        backgroundImage:
                                                                            AssetImage("assets/male2.png"),
                                                                        backgroundColor:
                                                                            Colors.blueGrey,
                                                                      ),
                                                                      Text(
                                                                        "Mandy",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.pink,
                                                                            fontSize: 16),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                OutlinedButton(
                                                                  onPressed:
                                                                      () {
                                                                    _auth
                                                                        .currentUser
                                                                        ?.updatePhotoURL(
                                                                            "assets/male3.png");
                                                                    Navigator.of(
                                                                            context)
                                                                        .popAndPushNamed(
                                                                            '/login');
                                                                    firestoreInstance
                                                                        .collection(
                                                                            'Users')
                                                                        .doc(
                                                                            '$uid')
                                                                        .update({
                                                                      'photourl':
                                                                          "assets/male3.png",
                                                                    });
                                                                  },
                                                                  style: OutlinedButton.styleFrom(
                                                                      side: BorderSide(
                                                                          width:
                                                                              5.0,
                                                                          color:
                                                                              Colors.transparent)),
                                                                  child: Column(
                                                                    children: [
                                                                      CircleAvatar(
                                                                        radius:
                                                                            32,
                                                                        backgroundImage:
                                                                            AssetImage("assets/male3.png"),
                                                                        backgroundColor:
                                                                            Colors.blueGrey,
                                                                      ),
                                                                      Text(
                                                                        "Sandy",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.blue[200],
                                                                            fontSize: 16),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                OutlinedButton(
                                                                  onPressed:
                                                                      () {
                                                                    _auth
                                                                        .currentUser
                                                                        ?.updatePhotoURL(
                                                                            "assets/Female1.png");
                                                                    Navigator.of(
                                                                            context)
                                                                        .popAndPushNamed(
                                                                            '/login');
                                                                    firestoreInstance
                                                                        .collection(
                                                                            'Users')
                                                                        .doc(
                                                                            '$uid')
                                                                        .update({
                                                                      'photourl':
                                                                          "assets/Female1.png",
                                                                    });
                                                                  },
                                                                  style: OutlinedButton.styleFrom(
                                                                      side: BorderSide(
                                                                          width:
                                                                              5.0,
                                                                          color:
                                                                              Colors.transparent)),
                                                                  child: Column(
                                                                    children: [
                                                                      CircleAvatar(
                                                                        radius:
                                                                            32,
                                                                        backgroundImage:
                                                                            AssetImage("assets/Female1.png"),
                                                                        backgroundColor:
                                                                            Colors.blueGrey,
                                                                      ),
                                                                      Text(
                                                                        "Alisha",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.orange,
                                                                            fontSize: 16),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                OutlinedButton(
                                                                  onPressed:
                                                                      () {
                                                                    _auth
                                                                        .currentUser
                                                                        ?.updatePhotoURL(
                                                                            "assets/Female2.png");
                                                                    Navigator.of(
                                                                            context)
                                                                        .popAndPushNamed(
                                                                            '/login');
                                                                    firestoreInstance
                                                                        .collection(
                                                                            'Users')
                                                                        .doc(
                                                                            '$uid')
                                                                        .update({
                                                                      'photourl':
                                                                          "assets/Female2.png",
                                                                    });
                                                                  },
                                                                  style: OutlinedButton.styleFrom(
                                                                      side: BorderSide(
                                                                          width:
                                                                              5.0,
                                                                          color:
                                                                              Colors.transparent)),
                                                                  child: Column(
                                                                    children: [
                                                                      CircleAvatar(
                                                                        radius:
                                                                            32,
                                                                        backgroundImage:
                                                                            AssetImage("assets/Female2.png"),
                                                                        backgroundColor:
                                                                            Colors.blueGrey,
                                                                      ),
                                                                      Text(
                                                                        "Nora",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.pink,
                                                                            fontSize: 16),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                OutlinedButton(
                                                                  onPressed:
                                                                      () {
                                                                    _auth
                                                                        .currentUser
                                                                        ?.updatePhotoURL(
                                                                            "assets/Female3.png");
                                                                    Navigator.of(
                                                                            context)
                                                                        .popAndPushNamed(
                                                                            '/login');
                                                                    firestoreInstance
                                                                        .collection(
                                                                            'Users')
                                                                        .doc(
                                                                            '$uid')
                                                                        .update({
                                                                      'photourl':
                                                                          "assets/Female3.png",
                                                                    });
                                                                  },
                                                                  style: OutlinedButton.styleFrom(
                                                                      side: BorderSide(
                                                                          width:
                                                                              5.0,
                                                                          color:
                                                                              Colors.transparent)),
                                                                  child: Column(
                                                                    children: [
                                                                      CircleAvatar(
                                                                        radius:
                                                                            32,
                                                                        backgroundImage:
                                                                            AssetImage("assets/Female3.png"),
                                                                        backgroundColor:
                                                                            Colors.blueGrey,
                                                                      ),
                                                                      Text(
                                                                        "Candice",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.blue[200],
                                                                            fontSize: 16),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            },
                                          ),
                                        ],
                                        elevation: 24,
                                      );
                                    },
                                  );
                                }
                              }on FirebaseAuthException catch (e) {
                                print(e);
                                if(e.code == 'weak-password'){
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                    false, // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor:
                                        Color.fromARGB(255, 56, 52, 52),
                                        title: const Text('Error Encountered',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25)),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: const <Widget>[
                                              Text(
                                                  "Your Password is too weak, make sure it's greater than 6 character's",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20)),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('OK',
                                                style: TextStyle(fontSize: 18)),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                        elevation: 24,
                                      );
                                    },
                                  );
                                }
                                else if (e.code == 'email-already-in-use'){
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                    false, // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor:
                                        Color.fromARGB(255, 56, 52, 52),
                                        title: const Text('Error Encountered',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25)),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: const <Widget>[
                                              Text(
                                                  "This E-Mail is already in use, kindly login using credentials",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20)),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('OK',
                                                style: TextStyle(fontSize: 18)),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                        elevation: 24,
                                      );
                                    },
                                  );
                                }
                              }
                              catch(e){
                                print(e);
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible:
                                  false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor:
                                      Color.fromARGB(255, 56, 52, 52),
                                      title: const Text('Error Encountered',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25)),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: const <Widget>[
                                            Text(
                                                "Something looks fishy, check the details entered or your network connectivity",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20)),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('OK',
                                              style: TextStyle(fontSize: 18)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                      elevation: 24,
                                    );
                                  },
                                );
                              }
                              //print(pno);
                            },
                            color: Color.fromRGBO(103, 199, 195, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                                child: Text("REGISTER",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.022,
                                        color: Colors.white))),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(12.0)),
                        /*Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Divider(
                                color: Colors.grey,
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                endIndent:
                                    MediaQuery.of(context).size.width * 0.01,
                                thickness: 2,
                              ),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.04,
                                child: Text("or",
                                    style: TextStyle(color: Colors.grey[700]))),
                            Expanded(
                              child: Divider(
                                color: Colors.grey,
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                endIndent:
                                    MediaQuery.of(context).size.height * 0.03,
                                thickness: 2,
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.all(12.0)),
                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                  onPressed: () {
                                    signInWithGoogle();
                                  },
                                  child: CircleAvatar(
                                    foregroundImage:
                                        AssetImage('assets/google.png'),
                                    backgroundColor: Colors.black,
                                    minRadius: 22,
                                    maxRadius: 26,
                                  )),
                              VerticalDivider(
                                thickness: 1,
                                color: Colors.grey,
                              ),
                              OutlinedButton(
                                  onPressed: () {},
                                  child: CircleAvatar(
                                    foregroundImage:
                                        AssetImage('assets/git.png'),
                                    backgroundColor: Colors.grey,
                                    minRadius: 22,
                                    maxRadius: 26,
                                  )),
                            ],
                          ),
                        ),*/
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.023,
                              color: Color.fromARGB(255, 128, 125, 125))),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Text("Login",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.023,
                                  color: Colors.white)))
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
