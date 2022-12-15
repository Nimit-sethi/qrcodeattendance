import 'package:attendanceapp/calendarscreen.dart';
import 'package:attendanceapp/model/currentUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

import 'model/user.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xffFF5F15);

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 40),
              child: Text(
                "Employee's List",
                style: TextStyle(
                  fontFamily: "NexaBold",
                  fontSize: screenWidth / 13,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight / 1.45,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Employee")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final snap = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: snap.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(
                              top: index > 0 ? 12 : 0, left: 6, right: 6),
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(2, 2),
                              ),
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  child: Container(
                                    margin: const EdgeInsets.only(),
                                    decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        snap[index]['id'],
                                        style: TextStyle(
                                          fontFamily: "NexaBold",
                                          fontSize: screenWidth / 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    QuerySnapshot snapReq =
                                        await FirebaseFirestore.instance
                                            .collection("Employee")
                                            .where('id',
                                                isEqualTo: snap[index]['id'])
                                            .get();
                                    setState(() {
                                      CurrentUser.id = snapReq.docs[0].id;

                                      print(CurrentUser.id);
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CalendarScreen(
                                                current_user: CurrentUser.id,
                                                current_user_id: snap[index]
                                                    ['id'],
                                              )),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
