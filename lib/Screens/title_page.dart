// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class titlePage extends StatefulWidget {
  const titlePage({Key? key}) : super(key: key);

  @override
  State<titlePage> createState() => _titlePageState();
}

class _titlePageState extends State<titlePage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.black, Color.fromRGBO(99, 108, 108, 1)])),
      child: Scaffold(
        // By defaut, Scaffold background is white
        // Set its value to transparent
          backgroundColor: Colors.transparent,
          body:SafeArea(child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: 180,),
                  SizedBox(height: 400,width: 200,
                  child: Column(
                    children: [
                      Image.asset("assets/2.png"),
                      SizedBox(height: 10,),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Tasker",style: TextStyle(fontSize:35,color: Color.fromRGBO(198, 230, 225, 1),fontWeight: FontWeight.bold),),
                        Text(" MSC",style: TextStyle(fontSize: 35,color: Color.fromRGBO(103, 199, 195, 1),fontWeight: FontWeight.bold),),
                      ],),
                    ],
                  )),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context,'/login');
                      // Respond to button press
                    },
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromRGBO(103, 199, 195, 1)),
                    minimumSize: MaterialStateProperty.all(const Size(300, 60)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: Text('Get Started',style: TextStyle(fontSize: 22,color: Colors.black,fontWeight: FontWeight.bold)),
                  ),
                  OutlinedButton(onPressed: (){
                    Navigator.pushNamed(context,'/regist');
                  },style: OutlinedButton.styleFrom(
                    minimumSize: Size(300, 60),
                    side: BorderSide(width: 2.0, color: Color.fromRGBO(103, 199, 195, 1)),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),child: Text("Sign Up",style: TextStyle(color:Color.fromRGBO(103, 199, 195, 1),fontSize: 22 ,fontWeight: FontWeight.bold),

                  )
                  )
                ],
              ),
            ],
          ),),

      ),
    );
  }
}
