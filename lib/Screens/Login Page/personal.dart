// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({Key? key}) : super(key: key);

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

Widget addList(String label) {
  //This method add the fields with any entry type
  return Container(
    margin: EdgeInsets.only(top: 20, left: 10, right: 10),
    child: TextFormField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        fillColor: Color.fromRGBO(33, 40, 51, 0),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(25),
        ),
        border: OutlineInputBorder(),
        labelStyle: TextStyle(color: Colors.white),
      ),
    ),
  );
}

class _PersonalDetailsState extends State<PersonalDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text("Personal Details"),
    ));
  }
}
