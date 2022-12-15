import 'package:attendanceapp/userdetails.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import 'loginscreen.dart';
import 'main.dart';
import 'model/admin.dart';
import 'model/user.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  TextEditingController controller = TextEditingController();
  // double? screenwidth;
  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = const Color(0xffFF5F15);
  final CountdownController _controller = CountdownController(autoStart: false);
  String barcodeData = "12345";
  // String scanResult = " ";
  // late SharedPreferences sharedPreferences;

  // Future<void> scanQR() async {
  //   String result = "";
  //
  //   try {
  //     result = await FlutterBarcodeScanner.scanBarcode(
  //       "#0000ff",
  //       "Cancel",
  //       false,
  //       ScanMode.BARCODE,
  //     );
  //   } catch (e) {
  //     print("ERROR");
  //   }
  //
  //   setState(() {
  //     scanResult = result;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    // screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(top: 60.0, left: 10, right: 10),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(top: 20, left: 15),
                              child: Text(
                                "Welcome,",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: "NexaRegular",
                                  fontSize: 30,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 15),
                              child: Text(
                                Admin.id.toUpperCase(),
                                style: TextStyle(
                                  fontFamily: "NexaBold",
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        // alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () async {
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            await sharedPreferences.clear();

                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyApp()),
                                (route) => false);
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            // margin: EdgeInsets.only(top: 40),
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            height: screenHeight / 13,
                            width: screenWidth / 2.3,
                            child: const Center(
                              child: Text(
                                "LOGOUT",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "NexaBold",
                                  color: Colors.white,
                                  fontSize: 20,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15, top: 30, bottom: 15),
                child: TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 10,
                    ),
                    hintText: 'Add text to convert to Qr Code',
                    // helperText: 'Helper Text',

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: screenHeight,
                child: BarcodeWidget(
                  data: barcodeData,
                  barcode: Barcode.qrCode(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Countdown(
                controller: _controller,
                seconds: 15,
                build: (_, double time) => Container(
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.black, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          time.toString(),
                          style: const TextStyle(
                            fontSize: 65,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 28.0),
                          child: Text(
                            "s",
                            style: const TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                interval: const Duration(milliseconds: 100),
                onFinished: () {
                  FirebaseFirestore.instance
                      .collection("Attributes")
                      .doc("Office1")
                      .set({
                    'code': " ",
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Timer is done!'),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Expanded(
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: GestureDetector(
                          onTap: () async {
                            if (controller.text.length >= 5) {
                              _controller.start();
                              if (_controller.isCompleted!) {
                                _controller.restart();
                              }
                              // Map<String,String> datatoAdd={
                              //   'code':controller.text,
                              // };
                              FirebaseFirestore.instance
                                  .collection("Attributes")
                                  .doc("Office1")
                                  .set({
                                'code': controller.text,
                              });

                              setState(() {
                                barcodeData = controller.text;
                              });
                            } else if (controller.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please enter text",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.SNACKBAR,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black54,
                                  textColor: Colors.white,
                                  fontSize: 15.0);
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      "Text entered must be at least 5 character long",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.SNACKBAR,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black54,
                                  textColor: Colors.white,
                                  fontSize: 15.0);
                            }
                          },
                          child: Container(
                            // margin: EdgeInsets.only(top: 40),
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            height: screenHeight / 11,
                            // width: screenWidth / 12,
                            child: const Center(
                              child: Text(
                                "Update QR Data",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "NexaBold",
                                  color: Colors.white,
                                  fontSize: 20,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30, left: 8.0),
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserDetails()),
                            );
                          },
                          child: Container(
                            // margin: EdgeInsets.only(top: 40),
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            height: screenHeight / 11,
                            width: double.infinity,
                            child: const Center(
                              child: Text(
                                "Employee Records",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "NexaBold",
                                  color: Colors.white,
                                  fontSize: 20,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
