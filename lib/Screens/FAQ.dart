import 'package:flutter/material.dart';

class faq extends StatefulWidget {
  const faq({Key? key}) : super(key: key);

  @override
  State<faq> createState() => _faqState();
}

class _faqState extends State<faq> {
  @override
  List<Map<String, dynamic>> _items = [
    {
      'id': 1,
      'title': 'Q1: How to I add a task?',
      'description':
          'Click on the Plus symbol in the bottom corner and fill in the details.',
      'isExpanded': false
    },
    {
      'id': 2,
      'title': 'Q2: How do I message my collaboraters?',
      'description':
          'Click on the message icon in the bottom bar < then select the person we want to msg.',
      'isExpanded': false
    },
    {
      'id': 3,
      'title': 'Q3: How do I create a google meet?',
      'description':
          'To create a gmeet simply assign a task to yourself or other and click on meeting to create it',
      'isExpanded': false
    },
    {
      'id': 4,
      'title': 'Q4: How do I keep check of all the tasks I have completed?',
      'description':
          'Simply go to the old stuff tab to see all the progress you have made till now.',
      'isExpanded': false
    },
    {
      'id': 5,
      'title': 'Q5: How do I add urgency priority to a task?',
      'description':
          'Simply add a task and then check the priority bar to set the priotity level of the task.',
      'isExpanded': false
    },
    {
      'id': 6,
      'title': 'Q5: WHAT IS MSC, KiiT Chapter ?',
      'description':
      'Microsoft Student Community, KiiT chapter , is a technical community, under the wing of  Microsoft Learn Student Ambassadors.  Our community is dedicatedly working on elevating the coding culture at Kalinga Institute of Industrial Technology, Bhubaneswar by providing opportunities to students to work on projects and  boost their analytical and logical skills along with the coding.',
      'isExpanded': false
    },
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 27, 33, 41),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('FAQs'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: ExpansionPanelList(
          elevation: 3,
          // Controlling the expansion behavior
          expansionCallback: (index, isExpanded) {
            setState(() {
              _items[index]['isExpanded'] = !isExpanded;
            });
          },
          children: _items
              .map(
                (item) => ExpansionPanel(
                  canTapOnHeader: true,
                  backgroundColor: item['isExpanded'] == true
                      ? Color.fromARGB(255, 64, 66, 69)
                      : Colors.transparent,
                  headerBuilder: (_, isExpanded) => Container(
                      padding: EdgeInsets.only(top: 20, left: 20),
                      child: Text(
                        item['title'],
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                  body: Column(
                    children: [
                      Divider(color: Colors.white),
                      Container(
                        padding: EdgeInsets.only(top: 15, left: 20, bottom: 30),
                        child: Text(item['description'],
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  isExpanded: item['isExpanded'],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
