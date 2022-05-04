import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  bool _passwordVisible = false;
  final _auth = FirebaseAuth.instance;
  String email = "";
  String pass = "";
  String uid = "";

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Color.fromARGB(255, 20, 24, 30),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.1),
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Email-ID",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.026,
                                    color: Colors.white)),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(5)),
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.9,
                          padding: EdgeInsets.only(left: 4),
                          child: TextFormField(
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter Your Email",
                                hintStyle: TextStyle(color: Colors.grey[700])),
                            onChanged: (value) {
                              email = value;
                            },
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 40)),
                        Row(
                          children: [
                            Icon(
                              Icons.admin_panel_settings_sharp,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Password",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.026,
                                    color: Colors.white)),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(5)),
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.9,
                          padding: EdgeInsets.only(left: 4),
                          child: TextFormField(
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password(>6)",
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
                            obscuringCharacter: '*',
                            onChanged: (value) {
                              pass = value;
                            },
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.322,
                        )),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.062,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(border: Border.all()),
                          //color: Colors.blue[900],
                          child: MaterialButton(
                            onPressed: () async {
                              try {
                                final user =
                                    await _auth.signInWithEmailAndPassword(
                                        email: email, password: pass);
                                if (user != null) {
                                  //print("Logged IN");
                                  if (user.user!.emailVerified) {
                                    uid = _auth.currentUser!.uid;
                                    Navigator.pushNamed(context, '/home');
                                  } else {
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible:
                                          false, // user must tap button!
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                              const Text('User not verified'),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: const <Widget>[
                                                Text(
                                                    'Please check your registered email and verify to proceed!'),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Accept'),
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
                                if (_auth.currentUser == null) {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('User Not Found'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: const <Widget>[
                                              Text(
                                                  'Please click on register to proceed!'),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Accept'),
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
                              } catch (e) {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible:
                                      false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor:
                                          Color.fromARGB(255, 56, 52, 52),
                                      title: const Text('Error',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: const <Widget>[
                                            Text(
                                                'Please check the credentials to proceed!\n\nPassword must be greater than 6 letters\n\nE-Mail must be verified',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Accept'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                      elevation: 24,
                                    );
                                  },
                                );
                                //print(e);
                              }
                            },
                            color: Color.fromRGBO(103, 199, 195, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "LOGIN",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.022,
                                  ),
                                ),
                                Icon(
                                  Icons.navigate_next,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        /*Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Divider(
                                color: Colors.grey,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
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
                  Padding(padding: EdgeInsets.only(top: 30)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.023,
                              color: Color.fromARGB(255, 128, 125, 125))),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/regist');
                          },
                          child: Text("Register",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.023,
                                  color: Colors.white)))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Password Recovery'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Text(
                                            'Enter registered email to get reset link.'),
                                        TextFormField(
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Enter Your Email",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[700])),
                                          onChanged: (value) {
                                            email = value;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Proceed'),
                                      onPressed: () {
                                        _auth.sendPasswordResetEmail(
                                            email: email);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                  elevation: 24,
                                );
                              },
                            );
                          },
                          child: Text("Forgot Password",
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
